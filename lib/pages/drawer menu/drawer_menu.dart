import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends StatefulWidget {
  final MenuItem currentMenuItem;
  final ValueChanged<MenuItem> onMenuItemSelected;
  const DrawerMenu({super.key, required this.currentMenuItem, required this.onMenuItemSelected});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  //! varibles declartion.
  String? name;
  String? email;
  String? imageUrl;

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
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              //! Drawer Header
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),
                    IconButton(
                      onPressed: () {
                        ZoomDrawer.of(context)!.close();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 16, top: 10),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          // User Image saction
                          child: CachedNetworkImage(
                            imageUrl: imageUrl ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQq6gaTf6N93kzolH98ominWZELW881HqCgw&s",
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    // User Name
                    Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 0),
                      child: Text(
                        name ?? "",
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    // User Email
                    Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 12),
                      child: Text(
                        email ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          //! Drawer Menu Item List
          Expanded(
            child: Column(
              children: [
                ...MenuItems.all.map(
                  (MenuItem item) {
                    return ListTileTheme(
                      selectedTileColor: myColors!.drawerListTileColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          selected: widget.currentMenuItem == item,
                          selectedColor: widget.currentMenuItem == item ? Colors.black : Colors.white,
                          leading: Icon(item.icon),
                          title: Text(item.title),
                          //! when we click on any ListTile then the propertie of that ListTile we passed to onMenuItemSelected() method.
                          onTap: () => widget.onMenuItemSelected(item),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          //! Logout Button.
          Padding(
            padding: const EdgeInsets.only(left: 2.5),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // ! Logout the user from any Logined Firebase Provider.
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
                selected: false,
                hoverColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
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

// ! Menu Items Class

class MenuItems {
  static const notesPage = MenuItem(title: "Notes", icon: Icons.edit_outlined);
  static const trashPage = MenuItem(title: "Trash", icon: Icons.delete_outline);
  static const settingsPage = MenuItem(title: "Settings", icon: Icons.settings_outlined);
  static const helpAndFeedbackPage = MenuItem(title: "Help & Feedback", icon: Icons.help_outline_outlined);

  static const all = <MenuItem>[
    notesPage,
    trashPage,
    settingsPage,
    helpAndFeedbackPage,
  ];
}

// ! Menu Item Class

class MenuItem {
  final String title;
  final IconData icon;
  const MenuItem({
    required this.title,
    required this.icon,
  });
}
