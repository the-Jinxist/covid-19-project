import 'package:covid_tracker_app/view/infected_page.dart';
import 'package:covid_tracker_app/view/location_page.dart';
import 'package:covid_tracker_app/view/notifications_page.dart';
import 'package:covid_tracker_app/view/scanner_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LocationPage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.location_city),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const NotificationsPage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Push the round button at the bottom of the screen to scan the QR code found at your location',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Icon(
              Icons.qr_code_2,
              size: 40,
              color: Colors.green.withOpacity(0.7),
            ),
            const SizedBox(
              height: 40,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    "If you believe you're suffering from any symptoms, you can confirm and inform people in your location ",
                style: const TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "here",
                    style: const TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const InfectedPage();
                            },
                          ),
                        );
                      },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const ScannerPage();
              },
            ),
          );
        },
        tooltip: 'Scan',
        child: const Icon(Icons.qr_code),
      ),
    );
    ;
  }
}
