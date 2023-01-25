import 'package:flutter/material.dart';

class ScannedResultPage extends StatelessWidget {
  final String locationString;
  final DateTime locationTime;

  const ScannedResultPage({
    super.key,
    required this.locationString,
    required this.locationTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        InkWell(
          onTap: () {
            //sendNoitification
            Navigator.of(context).pop();
          },
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.green,
            child: const Center(
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_city,
              size: 30,
              color: Colors.greenAccent,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'You just visited',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              locationString,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'We have saved the location and time into your database',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
