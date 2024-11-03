import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/providers/theme_provider.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //! Method to launch URLs.
  Future<void> _launchURL(Uri uri, bool inApp) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inApp) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
          );
        } else {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (error) {
      throw error.toString();
    }
  }

  //! Method for showing a dialog box for selecting themes.
  void showThemeDiologBox({required commanColor}) {
    showDialog(
      context: context,
      builder: (context) {
        return Selector<ThemeProvider, String>(
          selector: (context, value) => value.level,
          builder: (context, value, child) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Column(
                      children: [
                        SizedBox(height: 13),
                        Icon(Icons.color_lens),
                        SizedBox(height: 10),
                        Text(
                          "color scheme",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            context.read<ThemeProvider>().toggleRadiobtn("System");
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: "System",
                                groupValue: context.read<ThemeProvider>().level,
                                onChanged: (value) {
                                  context.read<ThemeProvider>().toggleRadiobtn(value);
                                },
                              ),
                              const SizedBox(width: 15),
                              const Text(
                                "System",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.read<ThemeProvider>().toggleRadiobtn("Light");
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: "Light",
                                groupValue: context.read<ThemeProvider>().level,
                                onChanged: (value) {
                                  context.read<ThemeProvider>().toggleRadiobtn(value);
                                },
                              ),
                              const SizedBox(width: 15),
                              const Text(
                                "Light",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.read<ThemeProvider>().toggleRadiobtn("Dark");
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: "Dark",
                                groupValue: context.read<ThemeProvider>().level,
                                onChanged: (value) {
                                  context.read<ThemeProvider>().toggleRadiobtn(value);
                                },
                              ),
                              const SizedBox(width: 15),
                              const Text(
                                "Dark",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    //! This method resets the radio selection value when the user dismisses or presses the back button.
                    context.read<ThemeProvider>().resetRadiobtn();
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<ThemeProvider>().setTheme();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //! Access theme extension colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        if (!value) {
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
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            //! Toggle the Zoom Drawer
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: const Icon(Icons.menu),
          ),
          title: const Text("S E T T I N G S"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Theme',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          showThemeDiologBox(
                            commanColor: myColors!.commanColor,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Row(
                                children: [
                                  Icon(Icons.color_lens),
                                  SizedBox(width: 10),
                                  Text(
                                    "Color scheme",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Chip(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                label: Selector<ThemeProvider, String>(
                                  selector: (context, value) => value.theme,
                                  builder: (context, value, child) {
                                    return Text(value);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Application Information',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      const ListTile(leading: Icon(Icons.info_outline), title: Text('App Version'), subtitle: Text('1.0.0')),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          _launchURL(
                            Uri.parse("https://github.com/kamesh7773/note_application"),
                            true,
                          );
                        },
                        child: const ListTile(
                          leading: FaIcon(FontAwesomeIcons.github),
                          title: Text('GitHub Repo'),
                        ),
                      ),
                      const ListTile(
                        leading: Icon(Icons.privacy_tip_outlined),
                        title: Text('Privacy Policy'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Developer Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const ListTile(leading: FaIcon(FontAwesomeIcons.user), title: Text('Name'), subtitle: Text('Kamesh Singh Sisodiya')),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          _launchURL(
                            Uri.parse("https://github.com/kamesh7773"),
                            true,
                          );
                        },
                        child: const ListTile(
                          leading: FaIcon(FontAwesomeIcons.github),
                          title: Text('GitHub Profile'),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          _launchURL(
                            Uri.parse("https://www.linkedin.com/in/kamesh-singh-5baab51ba/"),
                            true,
                          );
                        },
                        child: const ListTile(
                          leading: FaIcon(FontAwesomeIcons.linkedin),
                          title: Text('Linkedin'),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          _launchURL(
                            Uri.parse("https://www.instagram.com/kamesh_singh22?igsh=YzljYTk1ODg3Zg=="),
                            true,
                          );
                        },
                        child: const ListTile(
                          leading: FaIcon(FontAwesomeIcons.instagram),
                          title: Text('Instagram'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disclaimer',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.message),
                        subtitle: Text(
                          'Note it! is designed to help you manage your notes efficiently. While we strive to provide a reliable service, we cannot guarantee against data loss or corruption. Please back up important notes regularly. Account security is your responsibility. use strong, unique passwords. Note it! is not liable for any data loss, security breaches, or other issues arising from the use of this app.',
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
