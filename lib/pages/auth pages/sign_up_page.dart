import 'package:flutter/material.dart';
import 'package:note_application/helper/internet_checker.dart';
import 'package:note_application/helper/snackbar.dart';
import 'package:note_application/helper/form_validators.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/providers/toggle_provider.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:note_application/widgets/button_widget.dart';
import 'package:note_application/widgets/textformfeild_widget.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Create a key for the TextFormField widgets present in the SignUp screen
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  // Create TextEditingControllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method for registration
  void signUpMethod() {
    FirebaseAuthMethod.signUpWithEmail(
      fname: _firstNameController.text.trim(),
      lname: _lastNameController.text.trim(),
      userName: _userNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      context: context,
    );
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
            canPop: false,
            onPopInvoked: (value) {
              if (!value) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(
                          "assets/images/Notes_logo.png",
                          height: 75,
                          width: 75,
                          color: myColors!.commanColor,
                        ),

                        const SizedBox(height: 20),

                        // App name
                        const Text(
                          "Welcome! Let's get you started.",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              // ----------------------------
                              // TextFormField for first name
                              // ----------------------------
                              Expanded(
                                child: TextFormFeildWidget(
                                  hintText: "First name",
                                  obscureText: false,
                                  validator: FormValidator.userNameValidator,
                                  textEditingController: _firstNameController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // ----------------------------
                              // TextFormField for last name
                              // ----------------------------
                              Expanded(
                                child: TextFormFeildWidget(
                                  hintText: "Last name",
                                  obscureText: false,
                                  validator: FormValidator.userNameValidator,
                                  textEditingController: _lastNameController,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // -------------------
                        // Username text field
                        // -------------------
                        SizedBox(
                          width: 400,
                          child: TextFormFeildWidget(
                            hintText: "Username",
                            obscureText: false,
                            validator: FormValidator.userNameValidator,
                            textEditingController: _userNameController,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ---------------
                        // Email text field
                        // ---------------
                        SizedBox(
                          width: 400,
                          child: TextFormFeildWidget(
                            hintText: "Email",
                            obscureText: false,
                            validator: FormValidator.emailValidator,
                            textEditingController: _emailController,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ------------------
                        // Password text field
                        // ------------------
                        //! Provider Selector is used
                        Selector<ToggleProvider, bool>(
                          selector: (context, password) =>
                              password.showPassword,
                          builder: (context, value, child) {
                            return SizedBox(
                              width: 400,
                              child: TextFormFeildWidget(
                                hintText: "Password",
                                obscureText: value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      color: myColors.commanColor,
                                      value
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                  onPressed: () {
                                    context
                                        .read<ToggleProvider>()
                                        .showPasswordMethod();
                                  },
                                ),
                                validator: FormValidator.passwordValidator,
                                textEditingController: _passwordController,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              // SizedBox is used to set the alignment of the checkbox
                              SizedBox(
                                width: 26,
                                height: 24,
                                //! Provider Selector is used
                                child: Selector<ToggleProvider, bool>(
                                  selector: (context, raidoValue) =>
                                      raidoValue.isChecked,
                                  builder: (BuildContext context, value,
                                      Widget? child) {
                                    return Checkbox(
                                      activeColor: myColors.commanColor,
                                      value: value,
                                      onChanged: (value) {
                                        context
                                            .read<ToggleProvider>()
                                            .isCheckedMethod();
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("I agree to "),
                              const Text(
                                "Privacy Policy ",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                              const Text("and "),
                              const Text(
                                "Terms of Use",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Sign up button
                        SizedBox(
                          width: 400,
                          child: ButtonWidget(
                            onTap: () {
                              // First, check the form validation
                              _signUpFormKey.currentState!.validate();

                              // If form validation is successful and the Privacy Policy checkbox is not checked
                              if (_signUpFormKey.currentState!.validate() &&
                                  !context.read<ToggleProvider>().isChecked) {
                                SnackBars.normalSnackBar(
                                  context,
                                  "Please accept the Privacy Policy & Terms of Use",
                                );
                              }

                              // If form validation is successful and the Privacy Policy checkbox is also checked, then fire the sign-up method.
                              if (_signUpFormKey.currentState!.validate() &&
                                  context.read<ToggleProvider>().isChecked) {
                                signUpMethod();
                              }
                            },
                            color: myColors.buttonColor!,
                            text: "Sign Up",
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Already have an account? Login here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .popAndPushNamed("/LoginPage");
                              },
                              child: const Text(
                                "Login Here",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
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
            canPop: false,
            onPopInvoked: (value) {
              if (!value) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          Image.asset(
                            "assets/images/Notes_logo.png",
                            height: 80,
                            width: 100,
                            color: myColors!.commanColor,
                          ),

                          const SizedBox(height: 50),

                          // App name
                          const Text(
                            "Welcome! Let's get you started.",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 50),

                          Row(
                            children: [
                              // ----------------------------
                              // TextFormField for first name
                              // ----------------------------
                              Expanded(
                                child: TextFormFeildWidget(
                                  hintText: "First name",
                                  obscureText: false,
                                  validator: FormValidator.userNameValidator,
                                  textEditingController: _firstNameController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // ----------------------------
                              // TextFormField for last name
                              // ----------------------------
                              Expanded(
                                child: TextFormFeildWidget(
                                  hintText: "Last name",
                                  obscureText: false,
                                  validator: FormValidator.userNameValidator,
                                  textEditingController: _lastNameController,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // -------------------
                          // Username text field
                          // -------------------
                          TextFormFeildWidget(
                            hintText: "Username",
                            obscureText: false,
                            validator: FormValidator.userNameValidator,
                            textEditingController: _userNameController,
                          ),

                          const SizedBox(height: 10),

                          // ---------------
                          // Email text field
                          // ---------------
                          TextFormFeildWidget(
                            hintText: "Email",
                            obscureText: false,
                            validator: FormValidator.emailValidator,
                            textEditingController: _emailController,
                          ),

                          const SizedBox(height: 10),

                          // ------------------
                          // Password text field
                          // ------------------
                          //! Provider Selector is used
                          Selector<ToggleProvider, bool>(
                            selector: (context, password) =>
                                password.showPassword,
                            builder: (context, value, child) {
                              return TextFormFeildWidget(
                                hintText: "Password",
                                obscureText: value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      color: myColors.commanColor,
                                      value
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                  onPressed: () {
                                    context
                                        .read<ToggleProvider>()
                                        .showPasswordMethod();
                                  },
                                ),
                                validator: FormValidator.passwordValidator,
                                textEditingController: _passwordController,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              // SizedBox is used to set the alignment of the checkbox
                              SizedBox(
                                width: 26,
                                height: 24,
                                //! Provider Selector is used
                                child: Selector<ToggleProvider, bool>(
                                  selector: (context, raidoValue) =>
                                      raidoValue.isChecked,
                                  builder: (BuildContext context, value,
                                      Widget? child) {
                                    return Checkbox(
                                      activeColor: myColors.commanColor,
                                      value: value,
                                      onChanged: (value) {
                                        context
                                            .read<ToggleProvider>()
                                            .isCheckedMethod();
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("I agree to "),
                              const Text(
                                "Privacy Policy ",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                              const Text("and "),
                              const Text(
                                "Terms of Use",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Sign up button
                          ButtonWidget(
                            onTap: () async {
                              // Store internet state in a variable
                              bool isInternet =
                                  await InternetChecker.checkInternet();

                              // If there is no internet
                              if (isInternet && context.mounted) {
                                SnackBars.normalSnackBar(
                                    context, "Please turn on your Internet");
                              }
                              // If there is internet
                              else {
                                if (context.mounted) {
                                  // If form validation is successful and the Privacy Policy checkbox is not checked
                                  if (_signUpFormKey.currentState!.validate() &&
                                      !context
                                          .read<ToggleProvider>()
                                          .isChecked &&
                                      context.mounted) {
                                    SnackBars.normalSnackBar(
                                      context,
                                      "Please accept the Privacy Policy & Terms of Use",
                                    );
                                  }
                                  // If form validation is successful and the Privacy Policy checkbox is also checked, then fire the sign-up method.
                                  if (_signUpFormKey.currentState!.validate() &&
                                      context
                                          .read<ToggleProvider>()
                                          .isChecked) {
                                    signUpMethod();
                                  }
                                }
                              }
                            },
                            color: myColors.buttonColor!,
                            text: "Sign Up",
                          ),

                          const SizedBox(height: 20),

                          // Already have an account? Login here
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .popAndPushNamed("/LoginPage");
                                },
                                child: const Text(
                                  "Login Here",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
