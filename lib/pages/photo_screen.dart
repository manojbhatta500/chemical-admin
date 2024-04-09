import 'dart:developer';
import 'dart:io';
import 'package:apiadmin/pages/add_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';

class PhotoCaptureScreen extends StatefulWidget {
  @override
  _PhotoCaptureScreenState createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<PhotoCaptureScreen> {
  List<File> _imageList = [];

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageList.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _createPdf() async {
    final pdf.Document pdfDocument = pdf.Document();

    for (File imageFile in _imageList) {
      final image = pdf.MemoryImage(File(imageFile.path).readAsBytesSync());
      pdfDocument.addPage(pdf.Page(build: (pdf.Context context) {
        return pdf.Center(child: pdf.Image(image));
      }));
    }

    final Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory();

    final String pdfPath = '${appDocumentsDirectory.path}/chemical.pdf';

    try {
      final output = await File(pdfPath).create();
      await output.writeAsBytes(await pdfDocument.save());
      log('pdf created successfully');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddDataScreen(),
        ),
      );
    } catch (e) {
      log('Error creating PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Pdf')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _imageList.length,
              itemBuilder: (context, index) {
                return Image.file(_imageList[index]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _takePhoto,
                child: Text('Take Photo'),
              ),
              ElevatedButton(
                onPressed: _createPdf,
                child: Text('Create PDF'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
