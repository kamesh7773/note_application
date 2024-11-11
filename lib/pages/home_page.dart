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

  // Declare the current menu item
  MenuItem currentMenuItem = MenuItems.notesPage;

  @override
  Widget build(BuildContext context) {
    // Access theme extension colors
    final myColors = Theme.of(context).extension<MyColors>();

    // Method that return the selected page From ZoomDrawer and by default we return the HomePage().
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
      //! Zoom Drawer Menu.
      body: ZoomDrawer(
        controller: _drawerController,
        menuScreen: DrawerMenu(
          currentMenuItem: currentMenuItem,
          // This method contains the selected ListTile property and assigns it to the currentMenuItem, so our drawer page gets updated.
          onMenuItemSelected: (MenuItem item) {
            setState(
              () {
                currentMenuItem = item;
                // After selecting the item, close the drawer
                _drawerController.close!();
              },
            );
          },
        ),
        mainScreen: getSelectedPage(),
        closeCurve: Curves.easeInOut,
        angle: 0,
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
