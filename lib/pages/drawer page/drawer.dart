import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/pages/notes%20pages/help_feedback_page.dart';
import 'package:note_application/pages/notes%20pages/settings_page.dart';
import 'package:note_application/pages/notes%20pages/trash_page.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  final int iconNumber;
  const DrawerWidget({super.key, required this.iconNumber});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //! varibles declartion.
  String? name;
  String? email;
  String? imageUrl;

  bool notes = false;
  bool trash = false;
  bool settings = false;
  bool helpAndFeedback = false;

  //! Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name');
    email = prefs.getString('email');
    imageUrl = prefs.getString('imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    //! Finalizting which Menulist Item is active or which one is disable
    if (widget.iconNumber == 1) {
      notes = true;
    }
    if (widget.iconNumber == 2) {
      trash = true;
    }
    if (widget.iconNumber == 3) {
      settings = true;
    }
    if (widget.iconNumber == 4) {
      helpAndFeedback = true;
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              //! Drawer Header
              return Container(
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, bottom: 16, top: 20),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          // User Image saction
                          child: CachedNetworkImage(
                            imageUrl: imageUrl ??
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQq6gaTf6N93kzolH98ominWZELW881HqCgw&s",
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    // User Name
                    Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 0),
                      child: Text(
                        name ?? "",
                        style:
                            const TextStyle(fontSize: 19, color: Colors.black),
                      ),
                    ),
                    // User Email
                    Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 12),
                      child: Text(
                        email ?? "",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const Divider(
                      height: 0,
                    )
                  ],
                ),
              );
            },
          ),
          //! Drawer Menu Item List
          Expanded(
            child: ListView(
              //? By Setting "shrinkWrap: true" listview only takes height as much it need and it will not hole height.
              // shrinkWrap: true,  // now we don't need this because we are useing Expended.
              //? Used to remove Unwanted Padding from TOP of ListView()/ListView.builder()
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 6,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (widget.iconNumber == 1) {
                        return;
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomePage();
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: ListTile(
                      selected: notes,
                      selectedTileColor: Colors.grey.shade300,
                      hoverColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: const Icon(
                        Icons.edit_outlined,
                        size: 22,
                        color: Colors.black,
                      ),
                      title: const Text(
                        "Notes",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 6,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (widget.iconNumber == 2) {
                        return;
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return const TrashPage();
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: ListTile(
                      selected: trash,
                      selectedTileColor: Colors.grey.shade300,
                      hoverColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: const Icon(
                        Icons.delete_outline,
                        size: 22,
                        color: Colors.black,
                      ),
                      title: const Text(
                        "Trash",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 6,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (widget.iconNumber == 3) {
                        return;
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return const SettingsPage();
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: ListTile(
                      selected: settings,
                      selectedTileColor: Colors.grey.shade300,
                      hoverColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: const Icon(
                        Icons.settings_outlined,
                        size: 22,
                        color: Colors.black,
                      ),
                      title: const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 6,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (widget.iconNumber == 4) {
                        return;
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return const HelpAndFeedbackPage();
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: ListTile(
                      selected: helpAndFeedback,
                      selectedTileColor: Colors.grey.shade300,
                      hoverColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: const Icon(
                        Icons.help_outline_outlined,
                        size: 22,
                        color: Colors.black,
                      ),
                      title: const Text(
                        "Help & Feedback",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //! Logout Button.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                //! Logout the user from any Logined Firebase Provider.
                FirebaseAuthMethod.singOut(context: context);

                //! pushing user to login Screen of the application.s
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: ListTile(
                selectedTileColor: Colors.grey.shade300,
                selected: false,
                hoverColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: const Icon(
                  Icons.logout,
                  size: 22,
                  color: Colors.black,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text("version 1.0.0"),
          )
        ],
      ),
    );
  }
}
