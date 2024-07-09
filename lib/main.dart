import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:note_application/pages/auth%20pages/forgotPassword.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/pages/auth%20pages/sign_up_page.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/providers/comman_provider.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
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
      appId: "974432697808622",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }

  // checking user is previously login or not.
  bool isLogin = await FirebaseAuthMethod.isUserLogin();

  runApp(NoteApp(
    isLogin: isLogin,
  ));
}

class NoteApp extends StatelessWidget {
  final bool isLogin;
  const NoteApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerAndRadioButtonProvider>(
      create: (context) => TimerAndRadioButtonProvider(),
      child: MaterialApp(
        routes: {
          "/HomePage": (context) => const HomePage(),
          "/SignUpPage": (context) => const SignUpPage(),
          "/LoginPage": (context) => const LoginPage(),
          "/ForgotPasswordPage": (context) => const ForgotPasswordPage(),
        },
        theme: lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        home: isLogin ? const HomePage() : const LoginPage(),
      ),
    );
  }
}
