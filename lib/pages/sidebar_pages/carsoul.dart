import 'package:apiadmin/blocs/upload_banner/upload_banner_cubit.dart';
import 'package:apiadmin/pages/sidebar_pages/add_chemicals.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarasoulePage extends StatefulWidget {
  const CarasoulePage({super.key});

  @override
  State<CarasoulePage> createState() => _CarasoulePageState();
}

class _CarasoulePageState extends State<CarasoulePage> {
  TextEditingController title = TextEditingController();
  TextEditingController link = TextEditingController();

  late String selectedImagePath = '';
  PickedFileData? imageData;
  String? imagePath;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chemicals'),
      ),
      floatingActionButton: BlocListener<UploadBannerCubit, UploadBannerState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case UploadBannerSuccess:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Successfully posted banner')));
              link.clear();
              title.clear();
              // setState(() {
              //   imageData.fileName = null; // Clearing the fileName
              // });
              break;
            case UploadBannerLoading:
              print('this is loading state');
              break;
            case UploadBannerFailed:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Failed try Again')));
              break;
            default:
              print('this is running default');
          }
        },
        child: FloatingActionButton.extended(
          backgroundColor: Colors.lightBlueAccent,
          label: const Row(
            children: [
              Text(
                'Add Banner',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.post_add,
                color: Colors.white,
              )
            ],
          ),
          onPressed: () {
            BlocProvider.of<UploadBannerCubit>(context).changeUploadBannerCubit(
                title.text, imageData!.bytes!, link.text);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: link,
                decoration: const InputDecoration(
                  labelText: 'Link',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  imageData = await pickImage(context);
                  (context as Element).markNeedsBuild();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                child: const Text("Select Image")),
            imageData?.bytes != null ? Text(imageData!.fileName) : Text(""),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
