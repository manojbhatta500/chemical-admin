import 'dart:developer';
import 'package:apiadmin/blocs/fetch_category/fetch_category_cubit.dart';
import 'package:apiadmin/blocs/upload_pdf/upload_pdf_cubit.dart';
import 'package:apiadmin/models/category_model.dart';
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
  late String selectedPdfPath = ''; // Store file paths instead of names
  late String selectedImagePath = '';
  PickedFileData? pdfData;
  PickedFileData? imageData;

  String? imagePath;
  String? pdfPath;
  String? imageFileName;
  String? pdfFileName;

  Future<PickedFileData?> pickPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);
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
  void initState() {
    BlocProvider.of<FetchCategoryCubit>(context).changeFetchCategoryState();
    super.initState();
  }

  @override
  void dispose() {
    commonNameController.dispose();
    scientificNameController.dispose();
    super.dispose();
  }

  String? categoryName;
  String? categoryID;
  CategoryModel? categoryModel;

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

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
              BlocBuilder<FetchCategoryCubit, FetchCategoryState>(
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case FetchCategoryLoading:
                      return Text('loading categories ....');
                    case FetchCategoryFailed:
                      return Text('data fetching  failed');
                    case FetchCategorySuccess:
                      final data = state as FetchCategorySuccess;
                      return DropdownButton<CategoryModel>(
                        value: categoryModel,
                        hint: Text("Select Category"),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: const SizedBox(),
                        isExpanded: true,
                        items: data.categorydata.map((items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items.name!),
                          );
                        }).toList(),
                        onChanged: (catData) {
                          setState(() {
                            categoryModel = catData;
                            categoryID = categoryModel!.id;
                          });
                        },
                      );
                    default:
                      return const Text('Loading...');
                  }
                },
              ),
              const SizedBox(height: 20.0),
              TextButton(
                  onPressed: () async {
                    pdfData = await pickPdf(context);
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text("Select PDF")),
              pdfData?.bytes != null ? Text(pdfData!.fileName) : const Text(""),
              const SizedBox(height: 20.0),
              TextButton(
                  onPressed: () async {
                    imageData = await pickImage(context);
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text("Select Image")),
              imageData?.bytes != null ? Text(imageData!.fileName) : Text(""),
              const SizedBox(height: 20.0),
              BlocListener<UploadPdfCubit, UploadPdfState>(
                listener: (context, state) {
                  switch (state.runtimeType) {
                    case UploadPdfPending:
                      log('this is UploadPdfPending');
                    case UploadPdfSuccess:
                      log("this is upload pdf success method");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Successfully posted chemical.')));
                      commonNameController.clear();
                      scientificNameController.clear();

                    case UploadPdfFailed:
                      log("this is upload pdf failed");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Failed. Try again.')));
                    default:
                      log("this is default method");
                  }
                },
                child: ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<UploadPdfCubit>(context).hitPostServer(
                      commonName: commonNameController.text,
                      scientificName: scientificNameController.text,
                      categoryId: categoryID!,
                      imagebytes: imageData!.bytes!,
                      pdfbytes: pdfData!.bytes!,
                    );
                  },
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
