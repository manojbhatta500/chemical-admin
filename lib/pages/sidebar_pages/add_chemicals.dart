import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:apiadmin/blocs/upload_pdf/upload_pdf_cubit.dart';
import 'package:apiadmin/reposiotory/add_chemical_repo.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';

class PickedFileData {
  final String fileName;
  final List<int>? bytes;

  PickedFileData(this.fileName, this.bytes);
}

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
  PickedFileData? pdfData;
  PickedFileData? imageData;

  String? imagePath;
  String? pdfPath;
  String? imageFileName;
  String? pdfFileName;

  String getExtension(String imagePath) {
    // Get the file extension by splitting the file path at the last dot
    List<String> parts = imagePath.split('.');
    if (parts.length > 1) {
      // If there's more than one part after splitting, assume the last part is the extension
      String extension = parts.last.toLowerCase();
      // Check if the extension is one of the commonly used image extensions
      if (extension == 'jpg' ||
          extension == 'jpeg' ||
          extension == 'png' ||
          extension == "pdf") {
        return extension;
      }
    }
    // Default to empty string if the extension is not found or not supported
    return '';
  }

  Future<void> pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      final platformFile = result.files.single;
      final path = platformFile.name; // Getting file name instead of path
      final ext = getExtension(path);
      log("Extension$ext");
      setState(() {
        if (ext == 'pdf') {
          selectedPdfPath = path;
        } else {
          selectedImagePath = path;
        }
      });
    }
  }

/*  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      String fileName = file.path.split('/').last;
      String filePath = file.path;
      setState(() {
        pdfPath = filePath;
        pdfFileName = fileName;
      });
    }
  }*/
  Future<PickedFileData?> pickPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      PlatformFile file = result.files.first;
      return PickedFileData(file.name, file.bytes);
    }
    return null;
  }

  Future<PickedFileData?> pickImage(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      return PickedFileData(file.name, file.bytes);
    }
    return null;
  }

  // Future<void> pickImage() async {
  //   final result = await FilePicker.platform.pickFiles(allowMultiple: false);
  //   if (result != null) {
  //     File file = File(result.files.single.path ?? "");
  //     String fileName = file.path.split('/').last;
  //     String filePath = file.path;
  //     setState(() {
  //       imagePath = filePath;
  //       imageFileName = fileName;
  //     });
  //   }
  // }

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
      file: File(selectedPdfPath),
      // Convert path to File object
      image: File(selectedImagePath),
      // Handle optional image
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chemicals'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.2 * width),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: commonNameController,
                decoration: const InputDecoration(
                  labelText: 'Common Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: scientificNameController,
                decoration: const InputDecoration(
                  labelText: 'Scientific Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category', // Change to 'Category'
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                  onPressed: () async {
                    pdfData = await pickPdf(context);
                  },
                  child: const Text("Select PDF")),
              // _buildFileSelector(buttonText: 'Select PDF'),
              const SizedBox(height: 20.0),
              TextButton(
                  onPressed: () async {
                    imageData = await pickImage(context);
                  },
                  child: const Text("Select Image")),
              // _buildFileSelector(buttonText: 'Select Image'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // PickedFileData? pdfData = await pickPdf(context);
                  // PickedFileData? imageData = await pickImage(context);
                  ChemicalRepository repo = ChemicalRepository();
                  if (pdfData != null || imageData != null) {
                    bool success = await repo.uploadData(
                      commonNameController.text,
                      scientificNameController.text,
                      categoryController.text,
                      imageData!.bytes,
                      pdfData!.bytes,
                      imageData!.fileName ?? "",
                      pdfData!.fileName ?? "",
                    );
                    if (success) {
                      // Upload successful
                      log("success");
                    } else {
                      log("error");
                    }
                  } else {
                    log("no file picked");
                    // No files picked
                  }
                }, // Call submitData on button press
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
