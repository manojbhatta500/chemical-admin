import 'dart:developer';

import 'package:apiadmin/pages/photo_screen.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatelessWidget {
  AddDataScreen({super.key});

  TextEditingController commonName = TextEditingController();
  TextEditingController scientificName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: commonName,
              decoration: InputDecoration(
                labelText: 'Common Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: scientificName,
              decoration: InputDecoration(
                labelText: 'Scientific Name',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (commonName.text.isEmpty || scientificName.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                          'Common name and Scientific name are required')));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhotoCaptureScreen()));
                }
              },
              child: Text('Next'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
