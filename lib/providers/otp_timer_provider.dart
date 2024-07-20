import 'package:flutter/foundation.dart';
import 'dart:async';

class OtpTimerProvider extends ChangeNotifier {
  // variable's delcartion.
  bool _emailOtpSendBtnEnable = false;
  bool _forgotLinkBtbEnable = true;
  Duration _duration = const Duration(seconds: 60);
  Timer? _timer;

  OtpTimerProvider() {
    _emailOtpSendBtnEnable = false;
    _forgotLinkBtbEnable = true;
  }

  // declaring getters.
  bool get emailOtpSendBtnEnable => _emailOtpSendBtnEnable;
  bool get forgotLinkBtbEnable => _forgotLinkBtbEnable;
  Duration get duration => _duration;
  Timer? get timer => _timer;

  // declarting setters.
  set changeEmailOtpBtnValue(bool value) {
    _emailOtpSendBtnEnable = value;
    notifyListeners();
  }

  set changeForgotLinkBtnValue(bool value) {
    _forgotLinkBtbEnable = value;
    notifyListeners();
  }

  // Method that for OTP Timer.
  void startTimer() {
    _duration = const Duration(seconds: 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        timer.cancel();
        _emailOtpSendBtnEnable = true;
        _forgotLinkBtbEnable = true;
        _duration = const Duration(seconds: 60);
        notifyListeners();
      }
    });
  }

  //! Method reset the Timer & Button to default when click back button for chnage value or he/she by mistake press the back button.
  void resetTimerAndBtn() {
    _timer!.cancel();
    _emailOtpSendBtnEnable = false;
    _forgotLinkBtbEnable = true;
    _duration = const Duration(seconds: 60);
  }
}
