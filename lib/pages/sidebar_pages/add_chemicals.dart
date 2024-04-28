import 'dart:developer';
import 'dart:io';

import 'package:apiadmin/blocs/upload_pdf/upload_pdf_cubit.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker package
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddChemicals extends StatefulWidget {
  const AddChemicals({Key? key}) : super(key: key);

  @override
  State<AddChemicals> createState() => _AddChemicalsState();
}

class _AddChemicalsState extends State<AddChemicals> {
  late TextEditingController commonNameController = TextEditingController();
  late TextEditingController scientificNameController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();
  late String selectedPdfPath = ''; // Store file paths instead of names
  late String selectedImagePath = '';

  // Function to pick a file
  Future<void> pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      final path = result.files.single.path!;
      setState(() {
        if (type == 'pdf') {
          selectedPdfPath = path;
        } else {
          selectedImagePath = path;
        }
      });
    }
  }

  @override
  void dispose() {
    commonNameController.dispose();
    scientificNameController.dispose();
    super.dispose();
  }

  Widget _buildFileSelector({required String buttonText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => pickFile(buttonText.toLowerCase()), // Call pickFile
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
        Text(selectedPdfPath.isEmpty ? 'No PDF Selected' : selectedPdfPath),
      ],
    );
  }

  void submitData() async {
    String commonName = commonNameController.text;
    String scientificName = scientificNameController.text;
    String categoryId = categoryController.text;

    // Input Validation (Optional but recommended)
    if (commonName.isEmpty || scientificName.isEmpty || categoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    // Handle file availability (consider optional parameters in UploadPdfEvent)
    if (selectedPdfPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a PDF file.'),
        ),
      );
      return;
    }

    // Dispatch UploadPdfEvent with all required data
    BlocProvider.of<UploadPdfCubit>(context).hitPostServer(
      categoryId: categoryId,
      commonName: commonName,
      file: File(selectedPdfPath), // Convert path to File object
      image: File(selectedImagePath), // Handle optional image
      scientificName: scientificName,
    );

    // Clear form after successful submission (handle success/error states in BlocListener)
    commonNameController.clear();
    scientificNameController.clear();
    categoryController.clear();
    selectedPdfPath = '';
    selectedImagePath = '';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocListener<UploadPdfCubit, UploadPdfState>(
      listener: (context, state) {
        if (state is UploadPdfSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chemical uploaded successfully!'),
            ),
          );
        } else if (state is UploadPdfFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed! ${'upload pdf failed'}'),
            ),
          );
        }
      },
      child: Scaffold(
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
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category', // Change to 'Category'
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                _buildFileSelector(buttonText: 'Select PDF'),
                SizedBox(height: 20.0),
                _buildFileSelector(buttonText: 'Select Image'),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: submitData, // Call submitData on button press
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// this si great 