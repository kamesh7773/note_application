import 'dart:ui';

import 'package:colored_print/colored_print.dart';
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
            //! Drawer Header
            padding: EdgeInsets.zero,
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
                ),
                currentAccountPictureSize: const Size.fromRadius(30),
              ),
              //! Drawer Menu Item List
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: ListView(
                  //? Used to remove Unwanted Padding from TOP
                  padding: EdgeInsets.zero,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: -15, sigmaY: -15),
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ListTile(
                              selected: true,
                              selectedColor: Colors.blue,
                              hoverColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              leading: Transform.rotate(
                                angle: -372.2,
                                child: const Icon(
                                  Icons.edit,
                                  size: 22,
                                ),
                              ),
                              title: const Text(
                                "Notes",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* 

ListTile(
                              selected: true,
                              selectedColor: Colors.blue,
                              hoverColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              leading: Transform.rotate(
                                angle: -372.2,
                                child: const Icon(
                                  Icons.edit,
                                  size: 22,
                                ),
                              ),
                              title: const Text(
                                "Notes",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            
                             */