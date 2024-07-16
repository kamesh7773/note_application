import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:note_application/helper/form_validators.dart';
import 'package:note_application/providers/toggle_provider.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:note_application/widgets/button_widget.dart';
import 'package:note_application/widgets/textformfeild_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Creating Key for From Widget
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  // Creating TextEditing Controller's
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Remember me variable
  bool remeberMe = false;

  // disposing TextEditingController's
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method for login user
  void loginUser() {
    FirebaseAuthMethod.singInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      rememberMe: remeberMe,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _loginFormKey,
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

                  const SizedBox(height: 60),

                  // app name
                  const Text(
                    "Welcome back you've been missed!",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // email textfeild
                  TextFormFeildWidget(
                    hintText: "Email",
                    obscureText: false,
                    validator: FormValidator.emailValidator,
                    textEditingController: _emailController,
                  ),

                  const SizedBox(height: 10),

                  // password textfeild
                  //! Provider Selector is used
                  Selector<ToggleProvider, bool>(
                    selector: (context, password) => password.showPassword,
                    builder: (context, value, child) {
                      return TextFormFeildWidget(
                        hintText: "Password",
                        obscureText: value,
                        suffixIcon: IconButton(
                          color: myColors.commanColor,
                          icon: Icon(
                              value ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            context.read<ToggleProvider>().showPasswordMethod();
                          },
                        ),
                        validator: FormValidator.passwordValidator,
                        textEditingController: _passwordController,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Sizebox is used to set the alignment of checkbox
                          SizedBox(
                            width: 26,
                            height: 24,
                            child:
                                //! Provider Selector is used
                                Selector<ToggleProvider, bool>(
                              selector: (context, raidoValue) =>
                                  raidoValue.isChecked,
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return Checkbox(
                                  activeColor: myColors.commanColor,
                                  value: value,
                                  onChanged: (value) {
                                    //! Remember me varible initlization
                                    remeberMe = value ?? false;

                                    context
                                        .read<ToggleProvider>()
                                        .isCheckedMethod();
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Remember me",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("/ForgotPasswordPage");
                        },
                        child: const Text(
                          "Forgot Password ?",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  ButtonWidget(
                    onTap: () {
                      // Method that call all textfiled validator method
                      _loginFormKey.currentState!.validate();
                      // If Form Validation get completed only then call the Login() method
                      if (_loginFormKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    color: myColors.buttonColor!,
                    text: "Sign In",
                  ),

                  const SizedBox(height: 40),

                  const Text("Or continue with"),

                  const SizedBox(height: 40),

                  // continue with Google or fackbook
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FirebaseAuthMethod.signInWithGoogle(context: context);
                        },
                        child: Card(
                          color: myColors.googleFacebook,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          elevation: 8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: BackdropFilter(
                              filter: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                                  : ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: Image.asset(
                                  "assets/images/Google_logo.png",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          FirebaseAuthMethod.signInwithFacebook(
                            context: context,
                          );
                        },
                        child: Card(
                          color: myColors.googleFacebook,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: BackdropFilter(
                              filter: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                                  : ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  "assets/images/Facebook_logo.png",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // don't have an account ? Register here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("You don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).popAndPushNamed("/SignUpPage");
                        },
                        child: const Text(
                          "Register Here",
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
}
