import 'package:flutter/material.dart';
import 'package:note_application/pages/drawer%20page/drawer.dart';
import 'package:note_application/pages/home_page.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';

class HelpAndFeedbackPage extends StatefulWidget {
  const HelpAndFeedbackPage({super.key});

  @override
  State<HelpAndFeedbackPage> createState() => _HelpAndFeedbackPageState();
}

class _HelpAndFeedbackPageState extends State<HelpAndFeedbackPage> {
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
          title: const Text("H E L P  &  F E E D B A C K"),
          centerTitle: true,
        ),
        drawer: const DrawerWidget(iconNumber: 4),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ExpansionTile(
                iconColor: myColors!.commanColor,
                title: const Text('How do I create, update, or delete notes?'),
                children: const <Widget>[
                  ListTile(
                    title: Text(
                        'To create a note, use the floating action button located at the bottom right of the application. Once created, you can update or delete notes as needed.'),
                  ),
                ],
              ),
              ExpansionTile(
                iconColor: myColors.commanColor,
                title: const Text('How do I create an account?'),
                children: const <Widget>[
                  ListTile(
                    title: Text(
                        'You can create an account using Email & Password, or by continuing with Google or Facebook. If you forget your password, you can easily reset it using the "Forgot Password" option.'),
                  ),
                ],
              ),
              ExpansionTile(
                iconColor: myColors.commanColor,
                title: const Text('What happens when I delete a note?'),
                children: const <Widget>[
                  ListTile(
                    title: Text(
                        'When you delete a note, it moves to the Trash page and is not permanently deleted. Notes in the Trash will be automatically deleted after 7 days.'),
                  ),
                ],
              ),
              ExpansionTile(
                iconColor: myColors.commanColor,
                title: const Text('How do I change the app theme?'),
                children: const <Widget>[
                  ListTile(
                    title: Text(
                        'You can change the theme (Light or Dark Mode) of the application from the Settings page.'),
                  ),
                ],
              ),
              ExpansionTile(
                iconColor: myColors.commanColor,
                title: const Text(
                    'What information is available in the Settings page?'),
                children: const <Widget>[
                  ListTile(
                    title: Text(
                        'The Settings page contains information about the application such as version info, developer info, and the changelog of the application.'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Troubleshooting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ExpansionTile(
                iconColor: myColors.commanColor,
                title: const Text('The app is not loading properly'),
                children: const <Widget>[
                  ListTile(
                    title: Text(
                        'Try restarting the app and ensure you have a stable internet connection. If the issue persists, please contact support.'),
                  ),
                ],
              ),
              ExpansionTile(
                iconColor: myColors.commanColor,
                title: const Text('I found a bug'),
                children: const <Widget>[
                  ListTile(
                    title: Text(
                        'Please report any bugs using the feedback form below. Provide as much detail as possible to help us resolve the issue.'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'We value your feedback. Please let us know if you have any suggestions or encounter any issues.',
              ),
              const SizedBox(height: 16.0),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Your Feedback',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide:
                        BorderSide(width: 1.6, color: myColors.commanColor!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(width: 1.6, color: myColors.commanColor!),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: myColors.buttonColor,
                ),
                onPressed: () {
                  // Handle feedback submission
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: myColors.googleFacebook),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
