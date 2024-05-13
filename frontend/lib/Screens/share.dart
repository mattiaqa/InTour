import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/utils/api_manager.dart';
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
  bool selectMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Pubblica',
            style: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Visibility(
                visible: selectMode,
                child: Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _PickImageFromGallery();
                    },
                    child: Text("Carica dalla galleria"),
                  ),
                ),
              ),
              Visibility(
                visible: selectMode,
                child: SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: selectMode,
                child: Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    _PickImageFromCamera();
                  },
                  child: Text("Scatta una foto"),
                )),
              ),
              Visibility(
                visible: !selectMode,
                child: selectedImage != null
                    ? Image.file(selectedImage!)
                    : Text(''),
              ),
              Visibility(
                visible: !selectMode,
                child: SizedBox(
                  height: 30,
                ),
              ),
              Visibility(
                visible: !selectMode,
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Descrizione'),
                ),
              ),
              Visibility(
                visible: !selectMode,
                child: SizedBox(
                  height: 30,
                ),
              ),
              Visibility(
                visible: !selectMode,
                child: Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('OK'),
                      onPressed: () {
                        uploadImage(selectedImage!, descriptionController);
                      },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('SCARTA'),
                      onPressed: () {
                        setState(() {
                          selectMode = true;
                          selectedImage = null;
                        });
                      },
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }

  Future _PickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      selectMode = false;
      selectedImage = File(returnedImage.path);
    });
  }

  Future _PickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      selectMode = false;
      selectedImage = File(returnedImage.path);
    });
  }
}

Future<String?> getToken() async 
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

Future<bool> uploadImage(
    File selectedImage, TextEditingController descriptionController) async {
      String accessToken = await getToken() ?? "";
      

  final dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $accessToken';
  FormData formData = new FormData.fromMap({
    "description": descriptionController.text.toString(),
    "file": await MultipartFile.fromFile(selectedImage.path)
  });
  final response =
      await dio.post("http://$myIP:8000/api/post/upload", data: formData);
  return true;
}
