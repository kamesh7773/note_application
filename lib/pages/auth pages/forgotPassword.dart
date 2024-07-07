import 'package:flutter/material.dart';
import 'package:note_application/helper/firebase_auth_error_snackbar.dart';
import 'package:note_application/helper/form_validators.dart';
import 'package:note_application/helper/internet_checker.dart';
import 'package:note_application/providers/timer_and_checkmark_provider.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:note_application/widgets/textformfeild_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // declaring forgot password controllar
  TextEditingController _forgotPasswordController = TextEditingController();

  // Creating Key for forgot password FormTextFeild()
  final GlobalKey<FormState> forgotpasswordKey = GlobalKey<FormState>();

  // variables
  String btnText = "Sent Forgot Password Link";

  // resent OTP Method
  void resentOTP() async {
    // send the fortgot passoword link
    bool result = await FirebaseAuthMethod.forgotEmailPassword(
      email: _forgotPasswordController.text,
      context: context,
    );

    if (result) {
      // Restarting the TImer again & and disabling the OTP resent btn
      if (mounted) {
        context.read<TimerAndRadioButtonProvider>().startTimer();
        context.read<TimerAndRadioButtonProvider>().changeForgotLinkBtnValue =
            false;
      }
    } else {
      return;
    }
  }

  // initlizing forgotpassword controllers
  @override
  void initState() {
    super.initState();
    _forgotPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: forgotpasswordKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Don't worray sometimes people can forgot too.enter your email and we will send you a password reset link.",
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
                      child: Selector<TimerAndRadioButtonProvider, bool>(
                        selector: (context, emailForgotLinkBtn) =>
                            emailForgotLinkBtn.forgotLinkBtbEnable,
                        builder: (context, value, child) {
                          return ElevatedButton(
                            // Method that call resent OTP
                            onPressed: () async {
                              // storeing interent state in veriable
                              bool isInternet =
                                  await InternetChecker.checkInternet();

                              // If Form Validation get completed only then call the forgot link method
                              if (forgotpasswordKey.currentState!.validate() &&
                                  context.mounted) {
                                // if there is not internet
                                if (isInternet) {
                                  SnackBars.normalSnackBar(
                                      context, "Please turn on your Internet");
                                }
                                // if Internet connection is avaible
                                else if (!isInternet && context.mounted) {
                                  if (context
                                      .read<TimerAndRadioButtonProvider>()
                                      .forgotLinkBtbEnable) {
                                    resentOTP();
                                  }
                                  // else return nothing
                                  else {
                                    return;
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: context
                                      .read<TimerAndRadioButtonProvider>()
                                      .forgotLinkBtbEnable
                                  ? Colors.blue
                                  : const Color.fromARGB(255, 184, 181, 181),
                              foregroundColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              btnText,
                              style: TextStyle(
                                color: context
                                        .read<TimerAndRadioButtonProvider>()
                                        .forgotLinkBtbEnable
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
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
                        Selector<TimerAndRadioButtonProvider, Duration>(
                          selector: (context, otptimer) => otptimer.duration,
                          builder: (context, duration, child) {
                            return Text(
                              " 00:${duration.inSeconds.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
}
