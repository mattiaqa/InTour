import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  SharePageState createState() => SharePageState();
}

class SharePageState extends State<SharePage> {
  TextEditingController descriptionController = TextEditingController();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageTitle(title: 'Pubblica'),
        body: Center
        (
          child: Padding
          (
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 15),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>
            [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _PickImageFromGallery();
                  },
                  child: Text("Carica dalla galleria"),
                ),
              ),
              
              SizedBox(height: 10),
              
              Expanded(
                child: ElevatedButton(
                onPressed: () {
                  _PickImageFromCamera();
                },
                child: Text("Scatta una foto"),
                )
              )
            ],
          ),
          ) 
        ));
  }

  Future _PickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage.path);
    });
    context.push('/sharepreview', extra: selectedImage);
  }

  Future _PickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage.path);
    });
    context.push('/sharepreview', extra: selectedImage);
  }
}
