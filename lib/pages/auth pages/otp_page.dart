import 'package:flutter/material.dart';
import 'package:note_application/helper/snackbar.dart';
import 'package:note_application/helper/internet_checker.dart';
import 'package:note_application/providers/otp_timer_provider.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:lottie/lottie.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class EmailOtpPage extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String userName;
  final String password;
  const EmailOtpPage({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
  });

  @override
  State<EmailOtpPage> createState() => EmailOtpPageOtpPageState();
}

class EmailOtpPageOtpPageState extends State<EmailOtpPage> {
  // Creating a key for the email OTP text field form
  final GlobalKey<FormState> _emailOtpTextfiledFormKey = GlobalKey<FormState>();

  // Declaring a TextEditingController for the email OTP text field globally so it can also be used by the email OTP dialog box
  final TextEditingController _emailOtpController = TextEditingController();

  // Variables
  String? errorText;
  late String _emailOtp;

  // Verify OTP method
  void verifyOTP() {
    FirebaseAuthMethod.verifyEmailOTP(
      email: widget.email,
      emailOTP: _emailOtp,
      firstName: widget.firstName,
      lastName: widget.lastName,
      userName: widget.userName,
      password: widget.password,
      context: context,
    );
  }

  // Resend OTP method
  void resentOTP() {
    // Restart the timer and disable the OTP resend button
    context.read<OtpTimerProvider>().startTimer();
    context.read<OtpTimerProvider>().changeEmailOtpBtnValue = false;

    FirebaseAuthMethod.emailAuthResentOTP(
      email: widget.email,
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<OtpTimerProvider>().startTimer();
  }

  @override
  Widget build(BuildContext context) {
    //! Access theme extension colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return LayoutBuilder(
      builder: (context, constraints) {
        //! For desktops and tablets.
        if (constraints.maxWidth >= 1024) {
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (value , result) {
              if (value) {
                //! This method is called when the user presses the back button while filling the OTP on the OTP page. We need to cancel the current timer and disable
                //! the resend button again. If we don't do that, the timer will overlap, run very fast, and the resend button will be enabled even though
                //! the timer is running.
                context.read<OtpTimerProvider>().resetTimerAndBtn();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: myColors!.appBar,
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _emailOtpTextfiledFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Email.png',
                          fit: BoxFit.contain,
                          color: myColors.commanColor,
                          width: 100,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Verify your email address!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            widget.email,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const SizedBox(
                          width: 400,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Check your mailbox. We sent you an OTP on your email for verification. Once you verify your email, your account will be successfully created.",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // OTP text field for email OTP (Pinput)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Pinput(
                            length: 6,
                            controller: _emailOtpController,
                            autofocus: true,
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            errorText: errorText,
                            validator: (value) {
                              // If the text field is empty
                              if (value!.isEmpty) {
                                errorText = "OTP required";
                                return "OTP required";
                              }
                              // If OTP is less than 6 digits
                              else if (value.length < 6) {
                                errorText =
                                    "Make sure all OTP fields are filled in";
                                return "Make sure all OTP fields are filled in";
                              }
                              // Validating OTP
                              else if (!RegExp(r"^[0-9]{1,6}$")
                                  .hasMatch(value)) {
                                errorText = "Only digits are allowed";
                                return "Only digits are allowed";
                              }

                              // Else return nothing
                              else {
                                errorText = null;
                                return null;
                              }
                            },
                            onCompleted: (value) async {
                              // Storing internet state in a variable
                              bool isInternet =
                                  await InternetChecker.checkInternet();

                              // If OTP validation is not done, then return nothing, meaning nothing will happen
                              if (errorText != null) {
                                return;
                              }
                              // If there is no internet...
                              else if (isInternet && context.mounted) {
                                SnackBars.normalSnackBar(
                                    context, "Please turn on your Internet");
                              }
                              // If internet is available and validation is also completed
                              else if (errorText == null) {
                                // Assigning OTP to _emailOtp variable
                                _emailOtp = _emailOtpController.text.trim();
                                // Call the verify OTP method
                                verifyOTP();
                              }
                            },
                            errorTextStyle: TextStyle(
                              fontSize: 13,
                              color: myColors.commanColor,
                            ),
                            defaultPinTheme: PinTheme(
                              textStyle: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                              width: 44,
                              height: 46,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: myColors.commanColor!),
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Send OTP again in",
                                  style: TextStyle(fontSize: 16),
                                ),
                                //! Provider Selector is used
                                Selector<OtpTimerProvider, Duration>(
                                  selector: (context, otptimer) =>
                                      otptimer.duration,
                                  builder: (context, duration, child) {
                                    return Text(
                                      " 00:${duration.inSeconds.toString()}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                                const Text(" sec")
                              ],
                            ),
                            const SizedBox(height: 20),
                            //! Provider Selector is used
                            Selector<OtpTimerProvider, bool>(
                              selector: (context, otpBtn) =>
                                  otpBtn.emailOtpSendBtnEnable,
                              builder: (context, value, child) {
                                return TextButton(
                                  // Method that calls resend OTP
                                  onPressed: () async {
                                    // Storing internet state in a variable
                                    bool isInternet =
                                        await InternetChecker.checkInternet();

                                    // If there is no internet
                                    if (isInternet && context.mounted) {
                                      SnackBars.normalSnackBar(context,
                                          "Please turn on your Internet");
                                    }
                                    // If internet connection is available
                                    else {
                                      if (context.mounted) {
                                        if (value) {
                                          resentOTP();
                                        } else {
                                          return;
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Resend",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: value ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        //! For mobile phones
        else {
          return PopScope(
            canPop: true,
            onPopInvoked: (value) {
              if (value) {
                //! This method is called when the user presses the back button while filling the OTP on the OTP page. We need to cancel the current timer and disable
                //! the resend button again. If we don't do that, the timer will overlap, run very fast, and the resend button will be enabled even though
                //! the timer is running.
                context.read<OtpTimerProvider>().resetTimerAndBtn();
              }
            },
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _emailOtpTextfiledFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animation/mail_inbox.json',
                          fit: BoxFit.contain,
                          width: 300,
                          height: 200,
                        ),
                        const Text(
                          "Verify your email address!",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            widget.email,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Check your mailbox. We sent you an OTP on your email for verification. Once you verify your email, your account will be successfully created.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 50),
                        // OTP text field for email OTP (Pinput)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Pinput(
                            length: 6,
                            controller: _emailOtpController,
                            autofocus: true,
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            errorText: errorText,
                            validator: (value) {
                              // If the text field is empty
                              if (value!.isEmpty) {
                                errorText = "OTP required";
                                return "OTP required";
                              }
                              // If OTP is less than 6 digits
                              else if (value.length < 6) {
                                errorText =
                                    "Make sure all OTP fields are filled in";
                                return "Make sure all OTP fields are filled in";
                              }
                              // Validating OTP
                              else if (!RegExp(r"^[0-9]{1,6}$")
                                  .hasMatch(value)) {
                                errorText = "Only digits are allowed";
                                return "Only digits are allowed";
                              }

                              // Else return nothing
                              else {
                                errorText = null;
                                return null;
                              }
                            },
                            onCompleted: (value) async {
                              // Storing internet state in a variable
                              bool isInternet =
                                  await InternetChecker.checkInternet();

                              // If OTP validation is not done, then return nothing, meaning nothing will happen
                              if (errorText != null) {
                                return;
                              }
                              // If there is no internet...
                              else if (isInternet && context.mounted) {
                                SnackBars.normalSnackBar(
                                    context, "Please turn on your Internet");
                              }
                              // If internet is available and validation is also completed
                              else if (errorText == null) {
                                // Assigning OTP to _emailOtp variable
                                _emailOtp = _emailOtpController.text.trim();
                                // Call the verify OTP method
                                verifyOTP();
                              }
                            },
                            errorTextStyle: TextStyle(
                              fontSize: 13,
                              color: myColors!.commanColor,
                            ),
                            defaultPinTheme: PinTheme(
                              textStyle: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                              width: 54,
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myColors.commanColor!,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Send OTP again in"),
                                //! Provider Selector is used
                                Selector<OtpTimerProvider, Duration>(
                                  selector: (context, otptimer) =>
                                      otptimer.duration,
                                  builder: (context, duration, child) {
                                    return Text(
                                      " 00:${duration.inSeconds.toString()}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                                const Text(" sec")
                              ],
                            ),
                            const SizedBox(height: 20),
                            //! Provider Selector is used
                            Selector<OtpTimerProvider, bool>(
                              selector: (context, otpBtn) =>
                                  otpBtn.emailOtpSendBtnEnable,
                              builder: (context, value, child) {
                                return TextButton(
                                  // Method that calls resend OTP
                                  onPressed: () async {
                                    // Storing internet state in a variable
                                    bool isInternet =
                                        await InternetChecker.checkInternet();

                                    // If there is no internet
                                    if (isInternet && context.mounted) {
                                      SnackBars.normalSnackBar(context,
                                          "Please turn on your Internet");
                                    }
                                    // If internet connection is available
                                    else {
                                      if (context.mounted) {
                                        if (value) {
                                          resentOTP();
                                        } else {
                                          return;
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Resend",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: value ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
