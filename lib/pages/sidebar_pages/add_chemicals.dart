import 'dart:developer';

import 'package:flutter/material.dart';

class AddChemicals extends StatefulWidget {
  const AddChemicals({Key? key}) : super(key: key);

  @override
  State<AddChemicals> createState() => _AddChemicalsState();
}

class _AddChemicalsState extends State<AddChemicals> {
  late TextEditingController commonNameController = TextEditingController();
  late TextEditingController scientificNameController = TextEditingController();
  late String selectedPdfFileName = '';
  late String selectedImageFileName = '';

  @override
  void dispose() {
    commonNameController.dispose();
    scientificNameController.dispose();
    super.dispose();
  }

  Widget _buildFileSelector(
      {required String buttonText, required String selectedFileName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // Implement file selection logic here
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.blue),
          ),
        ),
        SizedBox(height: 10.0),
        Text(selectedFileName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Chemicals'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.2 * width),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: commonNameController,
                decoration: InputDecoration(
                  labelText: 'Common Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: scientificNameController,
                decoration: InputDecoration(
                  labelText: 'Scientific Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              _buildFileSelector(
                buttonText: 'Select PDF',
                selectedFileName: selectedPdfFileName,
              ),
              SizedBox(height: 20.0),
              _buildFileSelector(
                buttonText: 'Select Image',
                selectedFileName: selectedImageFileName,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  log('this is text');
                },
                child: Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
