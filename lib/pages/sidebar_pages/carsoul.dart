import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  // State variables for images, current index, and image picker
  final List<ImageProvider> _images = [];
  int _currentIndex = 0;
  final ImagePicker _imagePicker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(FileImage(File(image.path)));
      });
    }
  }

  // yes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Carousel'),
        actions: [
          // Add a button to pick images
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: _images.isEmpty
          ? const Center(child: Text('Select images to add to the carousel'))
          : Stack(
              children: [
                // Carousel widget to display images
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Adjust height as needed
                  child: PageView.builder(
                    itemCount: _images.length,
                    itemBuilder: (context, index) =>
                        Image(image: _images[index]),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 0.0,
                  right: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        width: _currentIndex == index ? 20.0 : 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: _images.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                print('Posting image: ${_images[_currentIndex].toString()}');
              },
              label: const Text('Post Selected Image'),
              icon: const Icon(Icons.send),
            ),
    );
  }
}
