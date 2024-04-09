import 'dart:developer';
import 'dart:io';
import 'package:apiadmin/bloc/post_chemical_data_bloc.dart';
import 'package:apiadmin/pages/add_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

int generateRandomNumber() {
  Random random = Random();
  return random.nextInt(1000) + 1;
}

class PhotoCaptureScreen extends StatefulWidget {
  final String cName;
  final String sName;
  PhotoCaptureScreen({required this.cName, required this.sName});
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
              BlocListener<PostChemicalDataBloc, PostChemicalDataState>(
                listener: (context, state) {
                  switch (state.runtimeType) {
                    case PostChemicalDataSuccess:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDataScreen(),
                        ),
                      );
                    case PostChemicalDataFailed:
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('please Try Again')));

                    default:
                      print('this is default option');
                  }
                },
                child: ElevatedButton(
                  onPressed: () async {
                    final pdf.Document pdfDocument = pdf.Document();

                    for (File imageFile in _imageList) {
                      final image = pdf.MemoryImage(
                          File(imageFile.path).readAsBytesSync());
                      pdfDocument
                          .addPage(pdf.Page(build: (pdf.Context context) {
                        return pdf.Center(child: pdf.Image(image));
                      }));
                    }

                    final Directory appDocumentsDirectory =
                        await getApplicationDocumentsDirectory();

                    // final String pdfPath =
                    //     '${appDocumentsDirectory.path}/chemical${generateRandomNumber}.pdf';

                    // print('pdfpath  : ${pdfPath}');

                    final String timestamp =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    final String pdfName =
                        'chemical_${widget.cName}_${widget.sName}_$timestamp.pdf';

                    final String pdfPath =
                        '${appDocumentsDirectory.path}/$pdfName';

                    try {
                      final output = await File(pdfPath).create();
                      await output.writeAsBytes(await pdfDocument.save());
                      print('pdf created successfully');
                      BlocProvider.of<PostChemicalDataBloc>(context).add(
                          OnCreatePdfBUttonPressed(
                              cName: widget.cName,
                              sName: widget.sName,
                              pdfName: pdfName,
                              pdfPath: pdfPath));
                    } catch (e) {
                      print('Error creating PDF: $e');
                    }
                  },
                  child: Text('Create PDF'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
