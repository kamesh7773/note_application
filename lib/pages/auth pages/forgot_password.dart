import 'package:flutter/material.dart';
import 'package:note_application/helper/snackbar.dart';
import 'package:note_application/helper/form_validators.dart';
import 'package:note_application/helper/internet_checker.dart';
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
        context.read<OtpTimerProvider>().startTimer();
        context.read<OtpTimerProvider>().changeForgotLinkBtnValue = false;
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
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(),
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
                      child: Selector<OtpTimerProvider, bool>(
                        selector: (context, emailForgotLinkBtn) =>
                            emailForgotLinkBtn.forgotLinkBtbEnable,
                        builder: (context, value, child) {
                          return ButtonWidget(
                            onTap: () async {
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
                                      .read<OtpTimerProvider>()
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
                            color: context
                                    .read<OtpTimerProvider>()
                                    .forgotLinkBtbEnable
                                ? myColors!.buttonColor!
                                : Theme.of(context).splashColor,
                            text: "Send Forgot Password Link",
                            textColor: context
                                    .read<OtpTimerProvider>()
                                    .forgotLinkBtbEnable
                                ? Colors.white
                                : const Color.fromARGB(255, 115, 114, 114),
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
