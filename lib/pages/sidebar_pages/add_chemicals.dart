import 'dart:developer';
import 'package:apiadmin/blocs/upload_pdf/upload_pdf_cubit.dart';
import 'package:apiadmin/reposiotory/add_chemical_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickedFileData {
  final String fileName;
  final List<int>? bytes;

  PickedFileData(this.fileName, this.bytes);
}

class AddChemicals extends StatefulWidget {
  const AddChemicals({super.key});

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

  @override
  void dispose() {
    commonNameController.dispose();
    scientificNameController.dispose();
    super.dispose();
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
              BlocListener<UploadPdfCubit, UploadPdfState>(
                listener: (context, state) {
                  switch (state.runtimeType) {
                    case UploadPdfPending:
                      log('this is UploadPdfPending');
                    case UploadPdfSuccess:
                      log("this is upload pdf success method");

                    case UploadPdfFailed:
                      log("this is upload pdf failed");

                    default:
                      log("this is default method");
                  }
                },
                child: ElevatedButton(
                  onPressed: () async {
                    // PickedFileData? pdfData = await pickPdf(context);
                    // PickedFileData? imageData = await pickImage(context);
                    //ChemicalRepository repo = ChemicalRepository();

                    BlocProvider.of<UploadPdfCubit>(context).hitPostServer(
                      commonName: commonNameController.text,
                      scientificName: scientificNameController.text,
                      categoryId: categoryController.text,
                      imagebytes: imageData!.bytes!,
                      pdfbytes: pdfData!.bytes!,
                    );

                    // ApiService service = ApiService();
                    // if (pdfData != null || imageData != null) {
                    //   bool success = await service.uploadData(
                    //     commonName: commonNameController.text,
                    //     scientificName: scientificNameController.text,
                    //     categoryId: categoryController.text,
                    //     imageBytes: imageData!.bytes!,
                    //     pdfBytes: pdfData!.bytes!,
                    //   );
                    //   if (success) {
                    //     // Upload successful
                    //     log("success");
                    //   } else {
                    //     log("error");
                    //   }
                    // } else {
                    //   log("no file picked");
                    //   // No files picked
                    // }
                  }, // Call submitData on button press
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
