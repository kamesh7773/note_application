import 'package:flutter/material.dart';
import 'package:note_application/pages/drawer%20page/drawer.dart';
import 'package:note_application/pages/home_page.dart';

class HelpAndFeedbackPage extends StatefulWidget {
  const HelpAndFeedbackPage({super.key});

  @override
  State<HelpAndFeedbackPage> createState() => _HelpAndFeedbackPageState();
}

class _HelpAndFeedbackPageState extends State<HelpAndFeedbackPage> {
  @override
  Widget build(BuildContext context) {
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
              const ExpansionTile(
                title: Text('How do I create, update, or delete notes?'),
                children: <Widget>[
                  ListTile(
                    title: Text(
                        'To create a note, use the floating action button located at the bottom right of the application. Once created, you can update or delete notes as needed.'),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('How do I create an account?'),
                children: <Widget>[
                  ListTile(
                    title: Text(
                        'You can create an account using Email & Password, or by continuing with Google or Facebook. If you forget your password, you can easily reset it using the "Forgot Password" option.'),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('What happens when I delete a note?'),
                children: <Widget>[
                  ListTile(
                    title: Text(
                        'When you delete a note, it moves to the Trash page and is not permanently deleted. Notes in the Trash will be automatically deleted after 7 days.'),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('How do I change the app theme?'),
                children: <Widget>[
                  ListTile(
                    title: Text(
                        'You can change the theme (Light or Dark Mode) of the application from the Settings page.'),
                  ),
                ],
              ),
              const ExpansionTile(
                title:
                    Text('What information is available in the Settings page?'),
                children: <Widget>[
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
              const ExpansionTile(
                title: Text('The app is not loading properly'),
                children: <Widget>[
                  ListTile(
                    title: Text(
                        'Try restarting the app and ensure you have a stable internet connection. If the issue persists, please contact support.'),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text('I found a bug'),
                children: <Widget>[
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
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Your Feedback',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                ),
                onPressed: () {
                  // Handle feedback submission
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
