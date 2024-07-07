import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:note_application/helper/user_login_or_not.dart';
import 'package:note_application/pages/auth%20pages/other_pages.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/pages/auth%20pages/sign_up_page.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/providers/timer_and_checkmark_provider.dart';
import 'package:note_application/services/firebase/firebase_options.dart';
import 'package:note_application/theme/dark_mode.dart';
import 'package:note_application/theme/light_mode.dart';
import 'package:provider/provider.dart';

void main() async {
  // Initlizing FireBase for Current Platform
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Imp code for facebook signIn/singUp for flutter web app only
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "990641889469194",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }

  // checking user is previously login or not.
  bool isLogin = await UserLoginStatus.isUserLogin();

  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerAndRadioButtonProvider>(
      create: (context) => TimerAndRadioButtonProvider(),
      child: MaterialApp(
        routes: {
          "/HomePage": (context) => const HomePage(),
          "/SignUpPage": (context) => const SignUpPage(),
          "/LoginPage": (context) => const LoginPage(),
          "/VerficationCompleted": (context) => const VerficationCompleted(),
          "/ForgotPasswordPage": (context) => const ForgotPasswordPage(),
        },
        theme: lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}
