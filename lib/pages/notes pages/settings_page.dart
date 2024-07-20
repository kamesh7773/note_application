import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_application/pages/drawer%20page/drawer.dart';
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
  //! Method that Launch URL's.
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

  //! Method for Showing Diolog box For Selected Themes.
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
                            context
                                .read<ThemeProvider>()
                                .toggleRadiobtn("System");
                          },
                          child: Row(
                            children: [
                              Radio(
                                activeColor: commanColor,
                                value: "System",
                                groupValue: context.read<ThemeProvider>().level,
                                onChanged: (value) {
                                  context
                                      .read<ThemeProvider>()
                                      .toggleRadiobtn(value);
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
                            context
                                .read<ThemeProvider>()
                                .toggleRadiobtn("Light");
                          },
                          child: Row(
                            children: [
                              Radio(
                                activeColor: commanColor,
                                value: "Light",
                                groupValue: context.read<ThemeProvider>().level,
                                onChanged: (value) {
                                  context
                                      .read<ThemeProvider>()
                                      .toggleRadiobtn(value);
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
                            context
                                .read<ThemeProvider>()
                                .toggleRadiobtn("Dark");
                          },
                          child: Row(
                            children: [
                              Radio(
                                activeColor: commanColor,
                                value: "Dark",
                                groupValue: context.read<ThemeProvider>().level,
                                onChanged: (value) {
                                  context
                                      .read<ThemeProvider>()
                                      .toggleRadiobtn(value);
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: commanColor,
                  ),
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
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
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
          title: const Text("S E T T I N G S"),
        ),
        drawer: const DrawerWidget(iconNumber: 3),
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
                                                  context
                                                      .read<ThemeProvider>()
                                                      .toggleRadiobtn("System");
                                                },
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      activeColor:
                                                          myColors!.commanColor,
                                                      value: "System",
                                                      groupValue: context
                                                          .read<ThemeProvider>()
                                                          .level,
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                ThemeProvider>()
                                                            .toggleRadiobtn(
                                                                value);
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
                                                  context
                                                      .read<ThemeProvider>()
                                                      .toggleRadiobtn("Light");
                                                },
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      activeColor:
                                                          myColors!.commanColor,
                                                      value: "Light",
                                                      groupValue: context
                                                          .read<ThemeProvider>()
                                                          .level,
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                ThemeProvider>()
                                                            .toggleRadiobtn(
                                                                value);
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
                                                  context
                                                      .read<ThemeProvider>()
                                                      .toggleRadiobtn("Dark");
                                                },
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      activeColor:
                                                          myColors.commanColor,
                                                      value: "Dark",
                                                      groupValue: context
                                                          .read<ThemeProvider>()
                                                          .level,
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                ThemeProvider>()
                                                            .toggleRadiobtn(
                                                                value);
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
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: myColors.commanColor,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          context
                                              .read<ThemeProvider>()
                                              .setTheme();
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      const ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text('App Version'),
                          subtitle: Text('1.0.0')),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          _launchURL(
                            Uri.parse(
                                "https://github.com/kamesh7773/note_application"),
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
                      const ListTile(
                          leading: FaIcon(FontAwesomeIcons.user),
                          title: Text('Name'),
                          subtitle: Text('Kamesh Singh Sisodiya')),
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
                            Uri.parse(
                                "https://www.linkedin.com/in/kamesh-singh-5baab51ba/"),
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
                            Uri.parse(
                                "https://www.instagram.com/kamesh_singh22?igsh=YzljYTk1ODg3Zg=="),
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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
