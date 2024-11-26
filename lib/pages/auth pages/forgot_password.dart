import 'package:flutter/material.dart';
import 'package:note_application/helper/snackbar.dart';
import 'package:note_application/helper/form_validators.dart';
import 'package:note_application/helper/internet_checker.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/providers/otp_timer_provider.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:note_application/widgets/button_widget.dart';
import 'package:note_application/widgets/textformfeild_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Declaring forgot password controller
  TextEditingController _forgotPasswordController = TextEditingController();

  // Creating a key for the forgot password FormTextField()
  final GlobalKey<FormState> forgotpasswordKey = GlobalKey<FormState>();

  // Variables
  String btnText = "Send Forgot Password Link";

  // Resend OTP method
  void resentOTP() async {
    // Send the forgot password link
    bool result = await FirebaseAuthMethod.forgotEmailPassword(
      email: _forgotPasswordController.text,
      context: context,
    );

    if (result) {
      // Restart the timer and disable the OTP resend button
      if (mounted) {
        context.read<OtpTimerProvider>().startTimer();
        context.read<OtpTimerProvider>().changeForgotLinkBtnValue = false;
      }
    } else {
      return;
    }
  }

  // Initializing forgot password controllers
  @override
  void initState() {
    super.initState();
    _forgotPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //! Access theme extension colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return LayoutBuilder(
      builder: (context, constraints) {
        //! For desktop & tablets.
        if (constraints.maxWidth >= 1024) {
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (value, result) {
              if (value) {
                //! This method is called when the user presses the back button in the middle of filling OTP on the OTP Page. We need to cancel the current timer and disable
                //! the Resend Button again. If we don't do that, the timer() will overlap, and the timer will run very fast, enabling the resend button even though
                //! the timer is running.
                context.read<OtpTimerProvider>().resetTimerAndBtn();
              }
            },
            child: Scaffold(
              appBar: AppBar(),
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: SafeArea(
                child: Form(
                  key: forgotpasswordKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: 400,
                            child: Text(
                              "Don't worry, sometimes people forget too. Enter your email, and we will send you a password reset link.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 400,
                            child: TextFormFeildWidget(
                              hintText: "E-mail",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.email),
                              validator: FormValidator.emailValidator,
                              textEditingController: _forgotPasswordController,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              //! Provider Selector is used
                              child: Selector<OtpTimerProvider, bool>(
                                selector: (context, emailForgotLinkBtn) => emailForgotLinkBtn.forgotLinkBtbEnable,
                                builder: (context, value, child) {
                                  return SizedBox(
                                    width: 400,
                                    child: ButtonWidget(
                                      onTap: () async {
                                        // Storing internet state in a variable
                                        bool isInternet = await InternetChecker.checkInternet();

                                        // If form validation is completed, only then call the forgot link method
                                        if (forgotpasswordKey.currentState!.validate() && context.mounted) {
                                          // If there is no internet
                                          if (isInternet) {
                                            SnackBars.normalSnackBar(context, "Please turn on your Internet");
                                          }
                                          // If internet connection is available
                                          else if (!isInternet && context.mounted) {
                                            if (context.read<OtpTimerProvider>().forgotLinkBtbEnable) {
                                              resentOTP();
                                            }
                                            // Else return nothing
                                            else {
                                              return;
                                            }
                                          }
                                        }
                                      },
                                      color: context.read<OtpTimerProvider>().forgotLinkBtbEnable ? myColors!.buttonColor! : Theme.of(context).splashColor,
                                      text: "Send Forgot Password Link",
                                      textColor: context.read<OtpTimerProvider>().forgotLinkBtbEnable ? Colors.white : const Color.fromARGB(255, 115, 114, 114),
                                    ),
                                  );
                                },
                              )),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Send OTP again in"),
                                //! Provider Selector is used
                                Selector<OtpTimerProvider, Duration>(
                                  selector: (context, otptimer) => otptimer.duration,
                                  builder: (context, duration, child) {
                                    return Text(
                                      " 00:${duration.inSeconds.toString()}",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                                const Text(" sec")
                              ],
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
            onPopInvokedWithResult: (value, result) {
              if (!value) {
                //! Navigating user to Login Page.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                  (Route<dynamic> route) => false,
                );

                //! This method is called when the user presses the back button in the middle of filling OTP on the OTP Page. We need to cancel the current timer and disable
                //! the Resend Button again. If we don't do that, the timer() will overlap, and the timer will run very fast, enabling the resend button even though
                //! the timer is running.
                context.read<OtpTimerProvider>().resetTimerAndBtn();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    //! Navigating user to Login Page.
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: SafeArea(
                child: Form(
                  key: forgotpasswordKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Don't worry, sometimes people forget too. Enter your email, and we will send you a password reset link.",
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormFeildWidget(
                          hintText: "E-mail",
                          obscureText: false,
                          prefixIcon: const Icon(Icons.email),
                          validator: FormValidator.emailValidator,
                          textEditingController: _forgotPasswordController,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            //! Provider Selector is used
                            child: Selector<OtpTimerProvider, bool>(
                              selector: (context, emailForgotLinkBtn) => emailForgotLinkBtn.forgotLinkBtbEnable,
                              builder: (context, value, child) {
                                return ButtonWidget(
                                  onTap: () async {
                                    // Storing internet state in a variable
                                    bool isInternet = await InternetChecker.checkInternet();

                                    // If form validation is completed, only then call the forgot link method
                                    if (forgotpasswordKey.currentState!.validate() && context.mounted) {
                                      // If there is no internet
                                      if (isInternet) {
                                        SnackBars.normalSnackBar(context, "Please turn on your Internet");
                                      }
                                      // If internet connection is available
                                      else if (!isInternet && context.mounted) {
                                        if (context.read<OtpTimerProvider>().forgotLinkBtbEnable) {
                                          resentOTP();
                                        }
                                        // Else return nothing
                                        else {
                                          return;
                                        }
                                      }
                                    }
                                  },
                                  color: context.read<OtpTimerProvider>().forgotLinkBtbEnable ? myColors!.buttonColor! : Theme.of(context).splashColor,
                                  text: "Send Forgot Password Link",
                                  textColor: context.read<OtpTimerProvider>().forgotLinkBtbEnable ? Colors.white : const Color.fromARGB(255, 115, 114, 114),
                                );
                              },
                            )),
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
                                selector: (context, otptimer) => otptimer.duration,
                                builder: (context, duration, child) {
                                  return Text(
                                    " 00:${duration.inSeconds.toString()}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              const Text(" sec")
                            ],
                          ),
                        ],
                      ),
                    ],
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
