import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:note_application/pages/drawer%20menu/drawer_menu.dart';
import 'package:note_application/pages/notes%20pages/help_feedback_page.dart';
import 'package:note_application/pages/notes%20pages/notes_pages.dart';
import 'package:note_application/pages/notes%20pages/settings_page.dart';
import 'package:note_application/pages/notes%20pages/trash_page.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Declare ZoomDrawerController
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  // Declaring Current Menu Item
  MenuItem currentMenuItem = MenuItems.notesPage;

  @override
  Widget build(BuildContext context) {
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    //! Method to get the selected page
    Widget getSelectedPage() {
      switch (currentMenuItem) {
        case MenuItems.notesPage:
          return const NotesPage();
        case MenuItems.trashPage:
          return const TrashPage();
        case MenuItems.settingsPage:
          return const SettingsPage();
        case MenuItems.helpAndFeedbackPage:
          return const HelpAndFeedbackPage();
        default:
          return const NotesPage();
      }
    }

    return Scaffold(
      body: ZoomDrawer(
        controller: _drawerController,
        menuScreen: DrawerMenu(
          currentMenuItem: currentMenuItem,
          //! This method contain the selected ListTile propertie and we assigne that selected ListTile to CurrrentMenuItem so our Drawer Page
          //! get changed/updated.
          onMenuItemSelected: (MenuItem item) {
            setState(
              () {
                currentMenuItem = item;
                // after selecting the item, close the drawer
                _drawerController.close!();
              },
            );
          },
        ),
        mainScreen: getSelectedPage(),
        closeCurve: Curves.easeInOut,
        angle: 00,
        mainScreenScale: 0.14,
        borderRadius: 20,
        slideHeight: 10,
        slideWidth: 250,
        menuScreenWidth: 240,
        mainScreenTapClose: true,
        menuBackgroundColor: myColors!.appBar!,
      ),
    );
  }
}
