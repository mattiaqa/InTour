import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PictureUploader 
{
  static Future pickImage(ImageSource source) async
  {
    final returnedImage = await ImagePicker().pickImage(source: source);
    if (returnedImage == null) return;
    uploadImage(File(returnedImage.path));
  }

  static Future<bool> uploadImage(File selectedImage) async 
  {
    String accessToken = await getToken() ?? "";
    
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    FormData formData = new FormData.fromMap({
      "file": selectedImage.path.isNotEmpty ? await MultipartFile.fromFile(selectedImage.path) : ""
    });
    await dio.post("http://$myIP:8000/api/profile/edit/image", data: formData);
    return true;
  }

  static Future<String?> getToken() async 
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }
}
  