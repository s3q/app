import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UploadImagePagesWidget extends StatefulWidget {
  Function(Map<int, String>) onImageAdded;
  UploadImagePagesWidget({super.key, required this.onImageAdded});

  @override
  State<UploadImagePagesWidget> createState() => _UploadImagePagesWidgetState();
}

class _UploadImagePagesWidgetState extends State<UploadImagePagesWidget> {
  Map<int, String> _uploadedImagesPath = {
    1: "",
    2: "",
    3: "",
    4: "",
    5: "",
    6: "",
    7: "",
  };
  final ImagePicker _picker = ImagePicker();

//   void _pickImage() async {
//     final List<XFile>? images = await _picker.pickMultiImage();

//     if (images != null) {
//       images.forEach((e) {
//         _uploadedImagesPath = [e.path, ..._uploadedImagesPath];
//       });
//     }
//   }

//   void removeUploadedImage(value) {
//     bool re = _uploadedImagesPath.remove(value);
//     print(re);
//   }

//   void bookmarkMainPhoto(value) {
//     _uploadedImagesPath.remove(value);
//     _uploadedImagesPath.insertAll(0, value);
//     print("Home");
//   }

  @override
  Widget build(BuildContext context) {
    // print(_uploadedImagesPath);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 200,
            height: 200,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _uploadedImagesPath[1] = image.path;
                      });
                      widget.onImageAdded(_uploadedImagesPath);
                    }
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Icon(Icons.photo),
                  ),
                ),
                if (_uploadedImagesPath[1] != "")
                  Image.file(
                    File(_uploadedImagesPath[1]!),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Homepage"),
                ),
                if (_uploadedImagesPath[1] != "")
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _uploadedImagesPath[1] = "";
                          });
                          widget.onImageAdded(_uploadedImagesPath);
                        },
                        icon: Icon(
                          Icons.delete,
                        )),
                  ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width - 200,
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              //   shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                ..._uploadedImagesPath.keys.skip(1).map((e) {
                  return Container(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              setState(() {
                                _uploadedImagesPath[e] = image.path;
                              });
                              widget.onImageAdded(_uploadedImagesPath);
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Icon(Icons.photo),
                          ),
                        ),
                        if (_uploadedImagesPath[e] != "")
                          Image.file(
                            File(_uploadedImagesPath[e]!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        if (_uploadedImagesPath[e] != "")
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _uploadedImagesPath[e] = "";
                                  });
                                  widget.onImageAdded(_uploadedImagesPath);
                                },
                                icon: Icon(
                                  Icons.delete,
                                )),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
