import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:note_application/pages/auth%20pages/forgot_password.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/pages/auth%20pages/sign_up_page.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/pages/notes%20pages/help_feedback_page.dart';
import 'package:note_application/pages/notes%20pages/settings_page.dart';
import 'package:note_application/pages/notes%20pages/trash_page.dart';
import 'package:note_application/providers/layout_change_provider.dart';
import 'package:note_application/providers/otp_timer_provider.dart';
import 'package:note_application/providers/theme_provider.dart';
import 'package:note_application/providers/toggle_provider.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:note_application/services/firebase/firebase_options.dart';
import 'package:note_application/theme/themes.dart';
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

  // checking user is already login or not.
  bool isLogin = await FirebaseAuthMethod.isUserLogin();
  // checking user applied ThemeMode from Shared Preferences.
  bool savedTheme = await ThemeProvider.currentTheme();
  // Checking user applied Layout From Share Preferences.
  bool isGridView = await LayoutChangeProvider.currentLayout();

  runApp(NoteApp(
    isLogin: isLogin,
    savedTheme: savedTheme,
    isGridView: isGridView,
  ));
}

class NoteApp extends StatelessWidget {
  final bool isLogin;
  final bool savedTheme;
  final bool isGridView;
  const NoteApp({
    super.key,
    required this.isLogin,
    required this.savedTheme,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OtpTimerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToggleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LayoutChangeProvider(isGridView),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(savedTheme),
        ),
      ],
      child: Selector<ThemeProvider, bool>(
        selector: (context, mode) => mode.isDarkMode,
        builder: (context, value, child) {
          return MaterialApp(
            routes: {
              "/HomePage": (context) => const HomePage(),
              "/TrashPage": (context) => const TrashPage(),
              "/SettingsPage": (context) => const SettingsPage(),
              "/HelpAndFeedbackPage": (context) => const HelpAndFeedbackPage(),
              "/SignUpPage": (context) => const SignUpPage(),
              "/LoginPage": (context) => const LoginPage(),
              "/ForgotPasswordPage": (context) => const ForgotPasswordPage(),
            },
            theme: value ? NoteAppTheme.darkMode : NoteAppTheme.lightMode,
            debugShowCheckedModeBanner: false,
            home: isLogin ? const HomePage() : const LoginPage(),
          );
        },
      ),
    );
  }
}
