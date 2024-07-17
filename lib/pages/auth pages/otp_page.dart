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
  // Creating Key for phoneOtpTextfiledFormKey
  final GlobalKey<FormState> _emailOtpTextfiledFormKey = GlobalKey<FormState>();

  // Declaring Texediting controller for Phone OTP Textfeild globally so it can also be used by Phone OTP ShowDiologBox
  final TextEditingController _emailOtpController = TextEditingController();

  // variables
  String? errorText;
  late String _emailOtp;

// getting the otpBtnvalue from provider

  // verify OTP Method
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

  // resent OTP Method
  void resentOTP() {
    // Restarting the TImer again & and disabling the OTP resent btn
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
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return LayoutBuilder(
      builder: (context, constraints) {
        //! For Desktop & Tablets.
        if (constraints.maxWidth >= 1024) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: myColors!.toggleSwitch,
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
                            "Check your mail box, we sent you a OTP on your email for verification.Once you verify your email, your account will be successfully created.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // OTP TextFeild for Phone number OTP feild ( Pinput )
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Pinput(
                          length: 6,
                          controller: _emailOtpController,
                          autofocus: true,
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          errorText: errorText,
                          validator: (value) {
                            // if Textfield is empty
                            if (value!.isEmpty) {
                              errorText = "OTP required";
                              return "OTP required";
                            }
                            // if otp is lower then 6 digit's
                            else if (value.length < 6) {
                              errorText =
                                  "Make sure all OTP fields are filled in";
                              return "Make sure all OTP fields are filled in";
                            }
                            // validating Phone number
                            else if (!RegExp(r"^[0-9]{1,6}$").hasMatch(value)) {
                              errorText = "Only digit are allowed";
                              return "Only digit are allowed";
                            }

                            // else return nothing
                            else {
                              errorText = null;
                              return null;
                            }
                          },
                          onCompleted: (value) async {
                            // storeing interent state in veriable
                            bool isInternet =
                                await InternetChecker.checkInternet();

                            // if OTP Validation Not done then return nothing means nothing will happen
                            if (errorText != null) {
                              return;
                            }
                            // If Internet is not there then...
                            else if (isInternet && context.mounted) {
                              SnackBars.normalSnackBar(
                                  context, "Please turn on your Internet");
                            }
                            // if Internt is there & validation is also completed
                            else if (errorText == null) {
                              // assigning OTP to _emailOtp variable.
                              _emailOtp = _emailOtpController.text.trim();
                              // call the verify OTP Method
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
                              border: Border.all(color: myColors.commanColor!),
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
                          //! Provider Selector is used
                          Selector<OtpTimerProvider, bool>(
                            selector: (context, otpBtn) =>
                                otpBtn.emailOtpSendBtnEnable,
                            builder: (context, value, child) {
                              return TextButton(
                                // Method that call resent OTP
                                onPressed: () async {
                                  // storeing interent state in veriable
                                  bool isInternet =
                                      await InternetChecker.checkInternet();

                                  // if there is not internet
                                  if (isInternet && context.mounted) {
                                    SnackBars.normalSnackBar(context,
                                        "Please turn on your Internet");
                                  }
                                  // if Internet connection is avaible
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
          );
        }
        //! For Mobile Phone
        else {
          return PopScope(
            canPop: true,
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
                            "Check your mail box, we sent you a OTP on your email for verification.Once you verify your email, your account will be successfully created.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 50),
                        // OTP TextFeild for Phone number OTP feild ( Pinput )
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Pinput(
                            length: 6,
                            controller: _emailOtpController,
                            autofocus: true,
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            errorText: errorText,
                            validator: (value) {
                              // if Textfield is empty
                              if (value!.isEmpty) {
                                errorText = "OTP required";
                                return "OTP required";
                              }
                              // if otp is lower then 6 digit's
                              else if (value.length < 6) {
                                errorText =
                                    "Make sure all OTP fields are filled in";
                                return "Make sure all OTP fields are filled in";
                              }
                              // validating Phone number
                              else if (!RegExp(r"^[0-9]{1,6}$")
                                  .hasMatch(value)) {
                                errorText = "Only digit are allowed";
                                return "Only digit are allowed";
                              }

                              // else return nothing
                              else {
                                errorText = null;
                                return null;
                              }
                            },
                            onCompleted: (value) async {
                              // storeing interent state in veriable
                              bool isInternet =
                                  await InternetChecker.checkInternet();

                              // if OTP Validation Not done then return nothing means nothing will happen
                              if (errorText != null) {
                                return;
                              }
                              // If Internet is not there then...
                              else if (isInternet && context.mounted) {
                                SnackBars.normalSnackBar(
                                    context, "Please turn on your Internet");
                              }
                              // if Internt is there & validation is also completed
                              else if (errorText == null) {
                                // assigning OTP to _emailOtp variable.
                                _emailOtp = _emailOtpController.text.trim();
                                // call the verify OTP Method
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
                            //! Provider Selector is used
                            Selector<OtpTimerProvider, bool>(
                              selector: (context, otpBtn) =>
                                  otpBtn.emailOtpSendBtnEnable,
                              builder: (context, value, child) {
                                return TextButton(
                                  // Method that call resent OTP
                                  onPressed: () async {
                                    // storeing interent state in veriable
                                    bool isInternet =
                                        await InternetChecker.checkInternet();

                                    // if there is not internet
                                    if (isInternet && context.mounted) {
                                      SnackBars.normalSnackBar(context,
                                          "Please turn on your Internet");
                                    }
                                    // if Internet connection is avaible
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
