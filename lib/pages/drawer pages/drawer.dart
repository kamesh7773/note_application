import 'package:flutter/material.dart';
import 'package:note_application/pages/auth%20pages/login_page.dart';
import 'package:note_application/services/auth/firebase_auth_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colored_print/colored_print.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //! varibles declartion.
  String? name;
  String? email;
  String? imageUrl;
  int? currentindex;

  //! Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name');
    email = prefs.getString('email');
    imageUrl = prefs.getString('imageUrl');
  }

  //! List of Icons for MenuList of Drawer
  List<IconData> icon = [
    Icons.edit_outlined,
    Icons.delete_outline,
    Icons.settings_outlined,
    Icons.help_outline_outlined
  ];

  //! List of Name for MenuList of Drawer
  List<String> menuName = [
    "Notes",
    "Trash",
    "Settings",
    "Help & feedback",
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! Drawer Header
          FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              return UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text(
                  name ?? "",
                  style: const TextStyle(fontSize: 20),
                ),
                accountEmail: Text(email ?? ""),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    imageUrl ??
                        "https://www.pikpng.com/pngl/m/80-805068_my-profile-icon-blank-profile-picture-circle-clipart.png",
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                currentAccountPictureSize: const Size.fromRadius(30),
              );
            },
          ),
          //! Drawer Menu Item List
          Expanded(
            child: ListView.builder(
              //? By Setting "shrinkWrap: true" listview only takes height as much it need and it will not hole height.
              // shrinkWrap: true,  // now we don't need this because we are useing Expended.
              //? Used to remove Unwanted Padding from TOP of ListView()/ListView.builder()
              padding: EdgeInsets.zero,
              itemCount: menuName.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 6,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        currentindex = index;
                      });
                    },
                    child: ListTile(
                      selected: currentindex == index ? true : false,
                      selectedTileColor: Colors.grey.shade300,
                      hoverColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: Icon(
                        icon[index],
                        size: 24,
                        color: Colors.black,
                      ),
                      title: Text(
                        menuName[index],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
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
              child: const Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 15, top: 15),
                child: Row(
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.logout),
                  ],
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
