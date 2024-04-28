import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:quran_tracing/models/image_upload.dart';

class ImageUpload extends StatefulWidget {
  final Function(bool isUploaded, String imageName) uploaded;
  final String imageInitialUrl;

  const ImageUpload(this.imageInitialUrl, {super.key, required this.uploaded});
  @override
  State<ImageUpload> createState() {
    return _ImageUpload();
  }
}

Future<ImageUploadModel> imageUpload(File file) async {
  try {
    // Create a multi-part request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://quronhusnixati.uz:4000/file/upload'),
    );

    // Add the file to the request
    var stream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: file.path.split('/').last,
    );
    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    // Check the response status
    if (response.statusCode == 201) {
      // If successful, parse the response body and return the URL
      var responseData = await response.stream.bytesToString();
      return ImageUploadModel.fromJson(jsonDecode(responseData));
    } else {
      // If unsuccessful, throw an exception with an error message
      throw Exception(
          'Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions that occur during the request
    throw Exception('Failed to upload image: $e');
  }
}

class _ImageUpload extends State<ImageUpload> {
  var nameController;
  var priceController;

  File? _selectedImage;
  String? _imageName; // Changed from var to String
  bool _uploading = false;
  @override
  void initState() {
    super.initState();
    if (widget.imageInitialUrl.isNotEmpty) {
      _imageName = widget.imageInitialUrl;
    }
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
      _imageName = pickedImage.name; // Assigning pickedImage.name to _imageName
    });
    print(_imageName);
  }

  @override
  Widget build(BuildContext context) {
    void showSnackbarFileNotUploaded(BuildContext context) {
      const snackBar = SnackBar(
        content: Text('Avval faylni upload qiling'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void _handleUpload() async {
      setState(() {
        _uploading = true;
      });

      try {
        if (_selectedImage != null) {
          final imageUrl = await imageUpload(_selectedImage!);
          widget.uploaded(true, imageUrl.name);
          print(imageUrl.name);
          print('Image uploaded: $imageUrl');
        } else {
          showSnackbarFileNotUploaded(context);
        }
        // Handle success, e.g., save the image URL or navigate to the next screen
      } catch (e) {
        print('Failed to upload image: $e');
        widget.uploaded(false, '');
        // Handle error
      } finally {
        setState(() {
          _uploading = false;
        });
      }
    }

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 50,
                  width: 50, // Set a fixed width for the Container
                  alignment: Alignment.center,
                  child: _uploading
                      ? CircularProgressIndicator()
                      : _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : _imageName != null
                              ? Image.asset(
                                  "assets/images/login_image.png",
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  _imageName ?? 'file-nomi', // Changed here
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(
                width: 8,
              ), // Use Expanded to allow flexible width
              OutlinedButton(
                onPressed: _uploading ? null : _handleUpload,
                child: Text('Faylni saqlash'),
              )
            ],
          ),
        ));
  }
}
