// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:note_application/pages/auth%20pages/forgotPassword.dart';
// import 'package:note_application/pages/auth%20pages/login_page.dart';
// import 'package:note_application/pages/auth%20pages/sign_up_page.dart';
// import 'package:note_application/pages/home_page.dart';
// import 'package:note_application/pages/notes%20pages/help_feedback_page.dart';
// import 'package:note_application/pages/notes%20pages/settings_page.dart';
// import 'package:note_application/pages/notes%20pages/trash_page.dart';
// import 'package:note_application/providers/layout_change_provider.dart';
// import 'package:note_application/providers/otp_timer_provider.dart';
// import 'package:note_application/providers/toggle_provider.dart';
// import 'package:note_application/services/auth/firebase_auth_methods.dart';
// import 'package:note_application/services/firebase/firebase_options.dart';
// import 'package:note_application/theme/dark_mode.dart';
// import 'package:note_application/theme/light_mode.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   // Initlizing FireBase for Current Platform
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Imp code for facebook signIn/singUp for flutter web app only
//   if (kIsWeb) {
//     await FacebookAuth.i.webAndDesktopInitialize(
//       appId: "974432697808622",
//       cookie: true,
//       xfbml: true,
//       version: "v13.0",
//     );
//   }

//   // checking user is previously login or not.
//   bool isLogin = await FirebaseAuthMethod.isUserLogin();

//   runApp(NoteApp(
//     isLogin: isLogin,
//   ));
// }

// class NoteApp extends StatelessWidget {
//   final bool isLogin;
//   const NoteApp({super.key, required this.isLogin});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => OtpTimerProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => ToggleProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => LayoutChangeProvider(),
//         ),
//       ],
//       child: MaterialApp(
//         routes: {
//           "/HomePage": (context) => const HomePage(),
//           "/TrashPage": (context) => const TrashPage(),
//           "/SettingsPage": (context) => const SettingsPage(),
//           "/HelpAndFeedbackPage": (context) => const HelpAndFeedbackPage(),
//           "/SignUpPage": (context) => const SignUpPage(),
//           "/LoginPage": (context) => const LoginPage(),
//           "/ForgotPasswordPage": (context) => const ForgotPasswordPage(),
//         },
//         theme: lightMode,
//         darkTheme: darkMode,
//         debugShowCheckedModeBanner: false,
//         home: isLogin ? const HomePage() : const LoginPage(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:multiselect_scope/multiselect_scope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Multiselect Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //! Controllbar for MultiselectScope widget
  final MultiselectController _multiselectController = MultiselectController();

  //! variable declaration.
  bool isGridView = true;
  bool isAllSelected = false;

  //! List of ImageUrl that we use with GridView
  List<String> imageUrls = [
    "https://img.icons8.com/?size=48&id=TJX3x8NCUkFN&format=png",
    "https://img.icons8.com/?size=48&id=YCbKhwUNH1pc&format=png",
    "https://img.icons8.com/?size=48&id=PClBimo4GQGJ&format=png",
    "https://img.icons8.com/?size=48&id=jIM732ayEMfP&format=png",
    "https://img.icons8.com/?size=48&id=34ekiFycLzXv&format=png",
    "https://img.icons8.com/?size=48&id=629QE0a9taSF&format=png",
    "https://img.icons8.com/?size=48&id=Jd0d5Iz2TZIb&format=png",
    "https://img.icons8.com/?size=48&id=wuPAd75eU6lM&format=png",
    "https://img.icons8.com/?size=48&id=5cJddikxEAhI&format=png",
    "https://img.icons8.com/?size=48&id=WbSA1BjDR1gY&format=png",
    "https://img.icons8.com/?size=48&id=V2apQOyk6Gmy&format=png",
    "https://img.icons8.com/?size=48&id=jjfsc2prNeOb&format=png",
    "https://img.icons8.com/?size=48&id=qW0hxm9M3J5x&format=png",
  ];

  //! rebuild the UI Based on item selection.
  void listener() => setState(() {});

  @override
  void initState() {
    super.initState();

    _multiselectController.addListener(listener);
  }

  @override
  void dispose() {
    _multiselectController.addListener(listener);
    _multiselectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! Getting the value of how many item/items is got selected.
    final noOfItemSelected = _multiselectController.getSelectedItems();

    return Scaffold(
      appBar: _multiselectController.selectionAttached
          ? AppBar(
              backgroundColor: Colors.deepPurple[200],
              title: Text("${noOfItemSelected.length} Item is selected"),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    _multiselectController.clearSelection();
                  },
                  icon: const Icon(Icons.close)),
              actions: [
                Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                    value: isAllSelected,
                    onChanged: (value) {
                      setState(() {
                        isAllSelected = value!;

                        if (isAllSelected) {
                          _multiselectController.selectAll();
                        }
                        if (!isAllSelected) {
                          _multiselectController.clearSelection();
                        }
                      });
                    }),
                IconButton(
                    onPressed: () {
                      setState(() {
                        //! This is will return the list of selected Items.
                        final itemsToRemove = _multiselectController
                            .getSelectedItems()
                            .cast<String>();

                        //! This method remove the selected itesm from orignal list and modified the orignal List.
                        imageUrls = imageUrls
                            .where(
                                (element) => !itemsToRemove.contains(element))
                            .toList();

                        //! This one is just use to clear the selection so when we remove all the items then it will remove the select AppBar() thing.
                        _multiselectController.clearSelection();
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            )
          : AppBar(
              backgroundColor: Colors.deepPurple[200],
              title: const Text("MultiSelector"),
              centerTitle: true,
              actions: [
                isGridView
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                        icon: const Icon(Icons.grid_view_rounded),
                        color: Colors.black,
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                        icon: const Icon(Icons.list_alt),
                        color: Colors.black,
                      )
              ],
            ),
      body: MultiselectScope<String>(
        controller: _multiselectController,
        dataSource: imageUrls,
        clearSelectionOnPop: true,
        keepSelectedItemsBetweenUpdates: true,
        onSelectionChanged: (indexes, items) {
          debugPrint(
              'Custom listener invoked! Indexes: $indexes Items: $items');
          return;
        },
        //! if isGrid is TRUE then return ListView
        child: isGridView
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final controller = MultiselectScope.controllerOf(context);

                  final itemIsSelected = controller.isSelected(index);

                  return GestureDetector(
                    //! This will select the item when we long press but once item got selected it not work.
                    onLongPress: () {
                      if (!controller.selectionAttached) {
                        controller.select(index);
                      }
                    },
                    //! After one item got selected then onTap method work for select more then 1 items.
                    onTap: () {
                      if (controller.selectionAttached) {
                        controller.select(index);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: itemIsSelected
                                ? Border.all(
                                    color: Colors.lightBlueAccent, width: 2)
                                : Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: imageUrls[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            //! if isGrid is FALSE then return ListView
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          final controller =
                              MultiselectScope.controllerOf(context);

                          final itemIsSelected = controller.isSelected(index);

                          return GestureDetector(
                            //! This will select the item when we long press but once item got selected it not work.
                            onLongPress: () {
                              if (!controller.selectionAttached) {
                                controller.select(index);
                              }
                            },
                            //! After one item got selected then onTap method work for select more then 1 items.
                            onTap: () {
                              if (controller.selectionAttached) {
                                controller.select(index);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: itemIsSelected
                                        ? Border.all(
                                            color: Colors.lightBlueAccent,
                                            width: 2)
                                        : Border.all(),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrls[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
