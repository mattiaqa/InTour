import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Common/bottomMessage.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
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
  TextEditingController locationController = TextEditingController();
  
  late bool postable;
  late Widget shareStatus;
  Widget shareStatus_loading = SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(),
  );
  Widget shareStatus_clickable = Text(
    'Pubblica',
    style: TextStyle(fontSize: 16),
  );

  @override
  void initState() {
    shareStatus = shareStatus_clickable;
    postable = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageTitle(title: 'Pubblica'),
        body: Center
        (
          child: Padding
          (
            padding: EdgeInsets.only(bottom: 30, left: 15, right: 15),
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
                  decoration: InputDecoration(
                    hintText: 'Descrizione',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(Icons.description),
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'Aggiungi una posizione',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(Icons.location_on),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        final selectedLocation = await context.push('/percorsi', extra: true);
                        if (selectedLocation != null) {
                          setState(() {
                            locationController.text = selectedLocation as String;
                          });
                        }
                      },
                    ),
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),

                SizedBox(height: 30),
                
                Row(
                  children: 
                  [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          //foregroundColor: Colors.green,
                        ),
                        child: shareStatus,
                        onPressed: () {
                          setState(() {
                            postable = false;
                            shareStatus = shareStatus_loading;
                          });
                          if(postable)
                          {
                            uploadImage(widget.image, descriptionController.text, locationController.text)
                              .then((value){
                                if (value){
                                  context.go('/userprofile', extra: AppService.instance.currentUser!.userid);
                                  ShowBottomMessage(context, 'Post pubblicato con successo');
                                }
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          foregroundColor: const Color.fromARGB(255, 214, 102, 94),
                        ),
                        child: Text(
                          'Scarta',
                          style: TextStyle(fontSize: 16),
                        ),
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

Future<bool> uploadImage(File selectedImage, String description, String position) async {
  String accessToken = await getToken() ?? "";
      
  final dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $accessToken';
  FormData formData = new FormData.fromMap({
    "description": position + '\n' + description,
    "file": await MultipartFile.fromFile(selectedImage.path)
  });
  await dio.post("http://$myIP:8000/api/post/upload", data: formData);
  return true;
}