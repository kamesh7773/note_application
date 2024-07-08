import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //! varibles for file data.
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
    return Drawer(
      child: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          return ListView(
            children: [
              UserAccountsDrawerHeader(
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
                  image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage("assets/images/Note_background.jpg"),
                  ),
                ),
                currentAccountPictureSize: const Size.fromRadius(30),
              )
            ],
          );
        },
      ),
    );
  }
}
