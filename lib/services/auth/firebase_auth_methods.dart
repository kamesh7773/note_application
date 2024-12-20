import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:email_otp_auth/email_otp_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:note_application/pages/auth%20pages/otp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_application/helper/internet_checker.dart';
import 'package:note_application/helper/progress_indicator.dart';
import 'package:note_application/helper/snackbar.dart';

class FirebaseAuthMethod {
  // Variables related to Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Variables for Phone Authentication
  static late String _phoneOtpVerficationID;

  // Getter for verification ID that can be accessed by PhoneOTP Page
  // When resending OTP, a new verification ID is generated. We don't pass it through 
  // the constructor to avoid redirecting to a new OTP Page
  static String get phoneotpVerficatoinID => _phoneOtpVerficationID;

  // ---------------------------
  // Email Authentication Methods
  // ---------------------------

  //! Email & Password SignUp Method
  static Future<void> signUpWithEmail({
    required String fname,
    required String lname,
    required String userName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show Progress Indicator
      ProgressIndicators.showProgressIndicator(context);

      // Check if email exists with "Email & Password" provider in users collection
      QuerySnapshot queryForEmailAndProvider = await _db.collection('users')
          .where("email", isEqualTo: email)
          .where("provider", isEqualTo: "Email & Password")
          .get();

      // If email already exists with Email & Password provider
      if (queryForEmailAndProvider.docs.isNotEmpty && context.mounted) {
        Navigator.of(context).pop();
        SnackBars.normalSnackBar(
          context,
          "The email address is already in use by another account.",
        );
      }
      // If email doesn't exist or uses different provider
      else {
        if (context.mounted) {
          try {
            // Send OTP to user's email address
            await EmailOtpAuth.sendOTP(email: email);
            
            if (context.mounted) {
              Navigator.pop(context);
            }
          } catch (error) {
            if (context.mounted) {
              Navigator.pop(context);
              SnackBars.normalSnackBar(context, error.toString());
            }
          }

          // Check internet connection before proceeding
          bool isInternet = await InternetChecker.checkInternet();
          
          // Show error if no internet connection
          if (isInternet && context.mounted) {
            SnackBars.normalSnackBar(context, "Please turn on your Internet");
          }
          // If internet is available, redirect to OTP page
          else if (!isInternet && context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return EmailOtpPage(
                  email: email,
                  firstName: fname,
                  lastName: lname,
                  userName: userName,
                  password: password,
                );
              },
            ));
          }
        }
      }
    }
    // Handle Firebase Auth exceptions
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.popUntil(context, ModalRoute.withName("/SignUpPage"));
        SnackBars.normalSnackBar(context, "Please turn on your Internet");
      } else {
        if (context.mounted) {
          Navigator.popUntil(context, ModalRoute.withName("/SignUpPage"));
          SnackBars.normalSnackBar(context, error.message!);
        }
      }
    }
  }

  //! Verify Email OTP and create user account
  static Future<void> verifyEmailOTP({
    required email,
    required emailOTP,
    required firstName,
    required lastName,
    required userName,
    required password,
    required BuildContext context,
  }) async {
    try {
      ProgressIndicators.showProgressIndicator(context);
      
      // Verify the email OTP
      var res = await EmailOtpAuth.verifyOtp(
        otp: emailOTP,
      );

      // If OTP verification is successful, create user account and store data
      if (res["message"] == "OTP Verified") {
        try {
          // Create user account in Firebase Auth
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Store user data in Firestore
          await _db.collection("users").doc(_auth.currentUser!.uid).set({
            "name": "$firstName $lastName",
            "userName": userName,
            "email": email,
            "phoneNumber": "empty",
            "imageUrl": "https://p7.hiclipart.com/preview/782/114/405/5bbc3519d674c.jpg",
            "provider": "Email & Password",
            "userID": _auth.currentUser!.uid,
          });

          // Fetch current user info from Firestore
          final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();
          final userData = currentUserInfo.data();

          // Store user data in SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("name", userData!["name"]);
          await prefs.setString("userName", userData["userName"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("phoneNumber", userData["phoneNumber"]);
          await prefs.setString("imageUrl", userData["imageUrl"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);

          // Set login status
          await prefs.setBool('isLogin', true);

          // Redirect to HomePage after successful signup
          if (context.mounted) {
            Navigator.pop(context);
            SnackBars.normalSnackBar(context, "Your email account has been created successfully!");
            Navigator.of(context).popAndPushNamed("/HomePage");
          }
        }
        // Handle Firebase Auth exceptions during account creation
        on FirebaseAuthException catch (error) {
          if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
            Navigator.pop(context);
            Navigator.popUntil(context, ModalRoute.withName("/SignUpPage"));
            SnackBars.normalSnackBar(context, "Please turn on your Internet");
          } else {
            if (context.mounted) {
              Navigator.pop(context);
              Navigator.popUntil(context, ModalRoute.withName("/SignUpPage"));
              SnackBars.normalSnackBar(context, error.message!);
            }
          }
        }
      } else if (res["data"] == "Invalid OTP" && context.mounted) {
        SnackBars.normalSnackBar(context, "Invalid OTP");
      } else if (res["data"] == "OTP Expired" && context.mounted) {
        SnackBars.normalSnackBar(context, "OTP Expired");
      }
    }
    // Handle OTP verification errors
    catch (error) {
      if (error == "ClientException with SocketException: Failed host lookup: 'direct-robbi-kamesh-cc8a724a.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://direct-robbi-kamesh-cc8a724a.koyeb.app/_emailOtp-login") {
        if (context.mounted) {
          Navigator.pop(context);
          SnackBars.normalSnackBar(context, "Please turn on your Internet");
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          SnackBars.normalSnackBar(context, error.toString());
        }
      }
    }
  }

  //! Resend OTP on Email Method
  static Future<void> emailAuthResentOTP({required email, required BuildContext context}) async {
    try {
      // Showing the progress Indicator
      ProgressIndicators.showProgressIndicator(context);
      await EmailOtpAuth.sendOTP(email: email);
      // Poping of the Progress Indicator
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
    //? Handling E-mail OTP error's
    catch (error) {
      if (error == "ClientException with SocketException: Failed host lookup: 'direct-robbi-kamesh-cc8a724a.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://direct-robbi-kamesh-cc8a724a.koyeb.app/otp-login") {
        if (context.mounted) {
          // poping out the progress indicator
          SnackBars.normalSnackBar(context, "Please turn on your Internet");
        }
      } else {
        if (context.mounted) {
          // poping out the progress indicator
          SnackBars.normalSnackBar(context, error.toString());
        }
      }
    }
  }

  //! Email & Password Login Method
  static Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    try {
      // showing CircularProgressIndicator
      ProgressIndicators.showProgressIndicator(context);

      // Method for sing in user with email & password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // fetching current userId info from "users" collection.
      final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

      final userData = currentUserInfo.data();

      // creating instace of Shared Preferences.
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // writing current User info data to SharedPreferences.
      await prefs.setString("name", userData!["name"]);
      await prefs.setString("userName", userData["userName"]);
      await prefs.setString("email", userData["email"]);
      await prefs.setString("phoneNumber", userData["phoneNumber"]);
      await prefs.setString("imageUrl", userData["imageUrl"]);
      await prefs.setString("provider", userData["provider"]);
      await prefs.setString("userID", userData["userID"]);

      // setting isLogin to "true"
      await prefs.setBool('isLogin', rememberMe);

      // After login successfully redirecting user to HomePage
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context).popAndPushNamed("/HomePage");
      }
    }
    // Handling Login auth Exceptions
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.pop(context);
        SnackBars.normalSnackBar(context, "Please turn on your Internet");
      } else if (error.message == "The supplied auth credential is incorrect, malformed or has expired." && context.mounted) {
        Navigator.pop(context);
        SnackBars.normalSnackBar(context, "Invaild email or password");
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          SnackBars.normalSnackBar(context, error.message!);
        }
      }
    }
  }

  //! Email & Password ForgorPassword/Reset Method
  static Future<bool> forgotEmailPassword({
    required String email,
    required BuildContext context,
  }) async {
    // variable declartion
    late bool associatedEmail;
    try {
      // showing Progress Indigator
      ProgressIndicators.showProgressIndicator(context);
      //* 1st We check if the entered email address is already present & its provider is "Email & Password" in the "users" collection by querying FireStore's "users" Collection.
      // searching for Email Address & "Email & Password" provider in "users" collection at once
      QuerySnapshot queryForEmailAndProvider = await _db.collection('users').where("email", isEqualTo: email).where("provider", isEqualTo: "Email & Password").get();

      // if the entered Email address already present in "users" collection and Provider is "Email & Password"
      // it's means that user is entered corrent email address it's mean we can send that Forgot password link to user Email Address.
      if (queryForEmailAndProvider.docs.isNotEmpty && context.mounted) {
        // Method for sending forgot password link to user
        await _auth.sendPasswordResetEmail(email: email);
        // Poping of the Progress Indicator
        if (context.mounted) {
          Navigator.pop(context);
        }
        // Redirect user to ForgotPasswordHoldPage
        if (context.mounted) {
          SnackBars.normalSnackBar(
            context,
            "Forgot Password Link sended to your Email address",
          );
        }

        associatedEmail = true;
      }
      // if the entered Email address is not present in "users" collection or Entered email Provider is not "Email & Password" is present in "users" collection
      // that means user entered Email does not have associat account in Firebase realted to "Email & Password" Provider.
      else {
        if (context.mounted) {
          // Poping of the Progress Indicator
          Navigator.of(context).pop();

          SnackBars.normalSnackBar(
            context,
            "There is no associated account found with entered Email.",
          );
        }
        associatedEmail = false;
      }
    }
    // Handling forgot password auth Exceptions
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.pop(context);
        SnackBars.normalSnackBar(context, "Please turn on your Internet");
      } else if (error.message == "The supplied auth credential is incorrect, malformed or has expired." && context.mounted) {
        Navigator.pop(context);
        SnackBars.normalSnackBar(context, "Invaild email");
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          SnackBars.normalSnackBar(context, error.message!);
        }
      }
    }

    // returning email value
    return associatedEmail;
  }

  // --------------------------------------
  // Method related Google Auth (OAuth 2.0)
  // --------------------------------------

  //! Method for Google SingIn/SignUp (For Google We don't have two method for signIn/signUp)
  static Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      //? ------------------------
      //? Google Auth code for Web
      //? ------------------------
      // (For runing Google Auth on Web Browser We need add the Web Clint ID (Web Clint ID is avaible on Google Clound Console
      //  Index.html file ex : <meta name="google-signin-client_id" content="152173321595-lb4qla2alg7q3010hrip1p1i1ok997n9.apps.googleusercontent.com.apps.googleusercontent.com"> )
      //  Google Auth Only run on specific "Port 5000" for runing application ex : "flutter run -d edge --web-hostname localhost --web-port 5000"
      if (kIsWeb) {
        //* 1st create a googleProvider instance with the help of the GoogleAuthProvider class constructor.
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        //* 2nd Provider needs some kind of user Google account info for the sign-in process.
        //*     There are multiple providers are there in the google office website you can check them out.
        googleProvider.addScope("email");

        //* 3rd this code pop the google signIn/signUp interface/UI like showing google id that is logged in user's browser
        final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //* 4th storing user info inside the FireStore "users" collection.
        // ? Try & catch block for storing user info at Firestore in "users" collections
        try {
          // creating "users" collection so we can store user specific user data
          await _db.collection("users").doc(_auth.currentUser!.uid).set({
            "name": userCredential.additionalUserInfo!.profile!["name"],
            "userName": "empty",
            "email": userCredential.additionalUserInfo!.profile!["email"],
            "phoneNumber": "empty",
            "imageUrl": userCredential.additionalUserInfo!.profile!["picture"],
            "provider": "Google",
            "userID": _auth.currentUser!.uid,
          }).then((value) {
            debugPrint("User data saved in Firestore users collection");
          }).catchError((error) {
            debugPrint("User data not saved!");
          });

          // fetching current userId info from "users" collection.
          final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

          final userData = currentUserInfo.data();

          // creating instace of Shared Preferences.
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          //*
          await prefs.setString("name", userData!["name"]);
          await prefs.setString("userName", userData["userName"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("phoneNumber", userData["phoneNumber"]);
          await prefs.setString("imageUrl", userData["imageUrl"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);

          //* 6th setting isLogin to "true"
          await prefs.setBool('isLogin', true);
        }

        //? Handling Excetion for Storing user info at FireStore DB.
        on FirebaseAuthException catch (error) {
          if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
            SnackBars.normalSnackBar(context, "Please turn on your Internet");
          } else {
            if (context.mounted) {
              SnackBars.normalSnackBar(context, error.message!);
            }
          }
        }

        //* 7th After succresfully SingIn redirecting user to HomePage
        if (context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).popAndPushNamed("/HomePage");
        }

        // if "userCredential.additionalUserInfo!.isNewUser" is "isNewUser" it's mean user account is not presented on our firebase signin
        // console it mean's user is being SingIn/SingUp with Google for fisrt time so we can store the information in fireStore "users" collection.
        // This code used to detected when user login with Google Provider for first time and we can run some kind of logic on in.

        // if (userCredential.additionalUserInfo!.isNewUser) {}
      }
      //? --------------------------------
      //? Google Auth code for Android/IOS
      //? --------------------------------
      else {
        //* 1st this code pop the google signIn/signUp interface/UI like showing google id that is loged in user's devices
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //! if user Click on the back button while Google OAUth Popup is showing or he dismis the Google OAuth Pop By clicking anywhere on the screen then this under code\
        //! will pop-out the Progress Indicator.
        if (googleUser == null && context.mounted) {
          Navigator.of(context).pop();
        }

        //! if User Does Nothngs and continues to Google O Auth Sign In then this under code will executed.
        else {
          //* 2nd When user clicks on the Pop Google Account then this code retirve the GoogleSignInTokenData (accesToken/IdToken)
          final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

          // if accessToken or idToken null the return nothing. ( accessToken get null when user dismis the Google account Pop Menu)
          if (googleAuth?.accessToken == null && googleAuth?.idToken == null) {
            return;
          }
          // if accessToken and idToken is not null only then we process to login
          else {
            //* 3rd In upper code (2nd code ) we are ritrieving the "GoogleSignInTokenData" Instance (googleAuth) now with the help googleAuth instance we gonna
            //* retrive the "accessToken" and idToken
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );

            //* 4th This code help user to singIn/SingUp the user with Google Account.
            // when user click on the Popup google id's then this code will return all the User google account information
            // (Info like : Google account user name, user IMG, user email is verfied etc)
            UserCredential userCredential = await _auth.signInWithCredential(credential);

            //* 5th stroing user info inside the FireStore "users" collection.
            // ? Try & catch block for storing user info at Firestore in "users" collections
            try {
              // creating "users" collection so we can store user specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredential.additionalUserInfo!.profile!["name"],
                "userName": "empty",
                "email": userCredential.additionalUserInfo!.profile!["email"],
                "phoneNumber": "empty",
                "imageUrl": userCredential.additionalUserInfo!.profile!["picture"],
                "provider": "Google",
                "userID": _auth.currentUser!.uid,
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // fetching current userId info from "users" collection.
              final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

              final userData = currentUserInfo.data();

              // creating instace of Shared Preferences.
              final SharedPreferences prefs = await SharedPreferences.getInstance();

              //* 6th writing current User info data to SharedPreferences.
              await prefs.setString("name", userData!["name"]);
              await prefs.setString("userName", userData["userName"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("phoneNumber", userData["phoneNumber"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);

              //* 7th setting isLogin to "true"
              await prefs.setBool('isLogin', true);
            }

            //? Handling Excetion for Storing user info at FireStore DB.
            on FirebaseAuthException catch (error) {
              if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
                SnackBars.normalSnackBar(context, "Please turn on your Internet");
              } else {
                if (context.mounted) {
                  SnackBars.normalSnackBar(context, error.message!);
                }
              }
            }

            //* 8th After succresfully SingIn redirecting user to HomePage
            if (context.mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed("/HomePage");
            }

            //? if "userCredential.additionalUserInfo!.isNewUser" is "isNewUser" it's mean user account is not presented on our firebase signin
            //? console it mean's user is being SingIn/SingUp with Google for fisrt time so we can store the information in fireStore "users" collection.
            //? This code used to detected when user login with Google Provider for first time and we can run some kind of logic on in.

            // if (userCredential.additionalUserInfo!.isNewUser) {}
          }
        }
      }
    }
    //? Handling Error Related Google SignIn/SignUp.
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.pop(context);
        SnackBars.normalSnackBar(context, "Please turn on your Internet");
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          SnackBars.normalSnackBar(context, error.message!);
        }
      }
    }
  }

  // ----------------------------
  // Method related FaceBook Auth
  // ----------------------------

  //! Method for Facebook SingIn/SignUp
  static Future<void> signInwithFacebook({required BuildContext context}) async {
    try {
      //* 1st this code pop the Facebook signIn/signUp page in browser On Android
      //* and if we are web app then open Pop-Up Facebook signIn/signUp interface/UI In web browser
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (context.mounted) {
        ProgressIndicators.showProgressIndicator(context);
      }

      //! if user Click on the back button while FackBook AUth Browser Popup is showing or he dismis the FaceBook Auth Browser PopUp By clicking anywhere on the screen then this under code
      //! will pop-out the Progress Indicator.
      if (loginResult.accessToken == null && context.mounted) {
        Navigator.of(context).pop();
      }

      //! if User Does Nothngs and continues to Facebook Auth browser Sign In then this under code will executed.
      else {
        //* 2nd When user get login after entering their login password then this code retirve the FacebookTokenData.
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        // if accessToken or idToken null the return nothing.
        if (loginResult.accessToken == null) {
          return;
        }
        // if accessToken and idToken is not null only then we process to login
        else {
          //* 3rd this method singIn the user with credetial
          final UserCredential userCredentail = await _auth.signInWithCredential(facebookAuthCredential);

          //* 4th stroing user info inside the FireStore "users" collection.
          // ? Try & catch block for storing user info at Firestore in "users" collections
          try {
            // creating "users" collection so we can store user specific user data
            await _db.collection("users").doc(_auth.currentUser!.uid).set({
              "name": userCredentail.additionalUserInfo!.profile!["name"],
              "userName": "empty",
              "email": userCredentail.additionalUserInfo!.profile!["email"],
              "phoneNumber": "empty",
              "imageUrl": userCredentail.additionalUserInfo!.profile!["picture"]["data"]["url"],
              "provider": "Facebook",
              "userID": _auth.currentUser!.uid,
            }).then((value) {
              debugPrint("User data saved in Firestore users collection");
            }).catchError((error) {
              debugPrint("User data not saved!");
            });

            // fetching current userId info from "users" collection.
            final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

            final userData = currentUserInfo.data();

            // creating instace of Shared Preferences.
            final SharedPreferences prefs = await SharedPreferences.getInstance();

            //* 5th writing current User info data to SharedPreferences.
            await prefs.setString("name", userData!["name"]);
            await prefs.setString("userName", userData["userName"]);
            await prefs.setString("email", userData["email"]);
            await prefs.setString("phoneNumber", userData["phoneNumber"]);
            await prefs.setString("imageUrl", userData["imageUrl"]);
            await prefs.setString("provider", userData["provider"]);
            await prefs.setString("userID", userData["userID"]);

            //* 6th setting isLogin to "true"
            await prefs.setBool('isLogin', true);
          }

          //? Handling Excetion for Storing user info at FireStore DB.
          on FirebaseAuthException catch (error) {
            if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
              SnackBars.normalSnackBar(context, "Please turn on your Internet");
            } else {
              if (context.mounted) {
                SnackBars.normalSnackBar(context, error.message!);
              }
            }
          }

          //* 7th After succresfully SingIn redirecting user to HomePage
          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).popAndPushNamed("/HomePage");
          }
        }
      }
    }

    //? Handling Error Related Facebook SignIn/SignUp.
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        SnackBars.normalSnackBar(context, "Please turn on your Internet");
      } else if (error.message == "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address." && context.mounted) {
        SnackBars.normalSnackBar(context, "The email address is already in use by another account.");
      } else {
        if (context.mounted) {
          SnackBars.normalSnackBar(context, error.message!);
        }
      }
    }
  }
  
  // ------------------------------------
  // Method related Firebase Auth SingOut
  // ------------------------------------

  //! Method for SingOut Firebase Provider auth account
  static Future<void> singOut({required BuildContext context}) async {
    try {
      // Remove the entry's of Shared Preferences data.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('name');
      prefs.remove('email');
      prefs.remove('imageUrl');
      prefs.remove('userID');
      prefs.remove('provider');

      // seting isLogin to false.
      await prefs.setBool('isLogin', false);

      // SingOut code for Google SingIn/SingUp
      if (await GoogleSignIn().isSignedIn()) {
        // Sign out the user from google account
        GoogleSignIn().signOut();
      }
      // This method SignOut user from all firebase auth Provider's
      await _auth.signOut();
    }
    //? Handling Error Related Google SignIn/SignUp.
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        SnackBars.normalSnackBar(context, "Please turn on your Internet");
      } else {
        if (context.mounted) {
          SnackBars.normalSnackBar(context, error.message!);
        }
      }
    }
  }

  //! Method that check user is login or Not with any Provider.
  static Future<bool> isUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }
}
