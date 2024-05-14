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

class SharePreviewPage extends StatefulWidget {
  
  File image;
  
  SharePreviewPage(
    {
      Key? key,
      required this.image,
    }
  ) : super(key: key);

  @override
  SharePreviewPageState createState() => SharePreviewPageState();
}

class SharePreviewPageState extends State<SharePreviewPage> {
  TextEditingController descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageTitle(title: 'Pubblica'),
        body: Center
        (
          child: Padding
          (
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 15),
            child: SingleChildScrollView
            (
              child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>
              [
                Image.file(widget.image),
                
                SizedBox(height: 30),
                
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Descrizione'),
                ),
                
                SizedBox(height: 30),
                
                Row(
                  children: 
                  [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('OK'),
                        onPressed: () {
                          uploadImage(widget.image, descriptionController)
                            .then((value) 
                            {
                              if(value) context.go('/sharesuccess');
                            });
                        },
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton
                      (
                        child: Text('SCARTA'),
                        onPressed: () {
                          setState(() {
                            context.pop();
                          });
                        },
                      ),
                    ),
                  ]
                ),
              ],
            ),
            ) 
          ) 
        ));
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
  final response = await dio.post("http://$myIP:8000/api/post/upload", data: formData);
  return true;
}