import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Common/bottomMenu.dart';
import 'package:frontend/Screens/Common/emptyState.dart';
import 'package:frontend/Screens/Common/uploadPictures.dart';
import 'package:frontend/Screens/Profile/Components/friendrequest.dart';
import 'package:frontend/Screens/Profile/Components/posts.dart';
import 'package:frontend/Screens/Profile/Components/profiledata.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProfiloPage extends StatefulWidget {
  
  String username;
  
  ProfiloPage
  (
    {
      Key? key,
      required this.username
    }
  ) : super(key: key);

  @override
  _ProfiloPage createState() => _ProfiloPage();
}

class _ProfiloPage extends State<ProfiloPage> {
  @override
  Widget build(BuildContext context) 
  {
    return FutureBuilder
    (
      future: Future.wait([
        getUserData(widget.username), 
        getPostsOfUser(widget.username)
      ]),
      builder: (context, snapshot) 
      {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Scaffold(body: Center(child: CircularProgressIndicator(),),);
        if (snapshot.hasError)
          return Scaffold(body: Center(
            child: Text('Errore durante il recupero dei dati del profilo: ${snapshot.error}')
          ));
        
        Map<String,dynamic> userData = snapshot.data![0] as Map<String,dynamic>;
        List<dynamic> userPosts = snapshot.data![1] as List<dynamic>;
        return Scaffold
        (
          appBar: PageTitle
          (
            title: widget.username,
            actions: 
            [
              Visibility
              (
                visible: widget.username == AppService.instance.currentUser!.userid,
                child: IconButton
                (
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () 
                  {
                    AuthService.logout();
                    context.go('/login');
                  },
                )
              )
            ],
          ),
          body: SingleChildScrollView
          (
            child: Padding
            (
              padding: EdgeInsets.only(top: 20, left: 5, right: 5),
              child: Column
              (
                children: 
                [
                  Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: 
                    [
                      InkWell
                      (
                        child: ProfilePic(imagePath: userData['profile_image_url']),
                        onTap: () {
                          if(widget.username != AppService.instance.currentUser!.userid)
                            return;
                          ShowBottomMenu(context, "Modifica foto profilo", 
                          [
                            BottomMenuButton(
                              icon: Icons.photo_camera_outlined, 
                              text: "Scatta una foto", 
                              action: () => PictureUploader.pickImage(ImageSource.camera)
                            ),

                            BottomMenuButton(
                              icon: Icons.photo_library_outlined, 
                              text: "Scegli dalla galleria", 
                              action: () => PictureUploader.pickImage(ImageSource.gallery)
                            ),

                            BottomMenuButton(
                              icon: Icons.highlight_remove_rounded, 
                              text: "Rimuovi", 
                              action: () => PictureUploader.uploadImage(File(''))
                            ),
                          ]);
                        },
                      ),

                      Column
                      (
                        children:
                        [
                          ProfileData
                          (
                            posts: userPosts.length,
                            friends: userData['friends'].length
                          ),

                          SizedBox(height: 20),

                          FirendRequestButton
                          (
                            username: widget.username,
                            friends: userData['friends'],
                            friends_pending: userData['friends_pending'],
                            friends_request: userData['friends_request'],
                            onTap: () => setState(() {}),
                          )
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 50),

                  userPosts.isNotEmpty ?
                    PostsGrid(posts: userPosts)
                    :
                    Padding
                    (
                      padding: EdgeInsets.only(top: 100),
                      child: EmptyState(
                        icon: Icons.landscape_rounded,
                        message: 'Non hai ancora postato niente',
                      )
                    )
                    
                ],
              ),
            )
          )
        );
      }
    );
  }

  Future<List<dynamic>> getPostsOfUser(String user) async {
    String? data = await ApiManager.fetchData('profile/$user/posts');
    List<dynamic> allposts = json.decode(data!);

    return allposts.reversed.toList();
  }

  Future<Map<String,dynamic>> getUserData(String user) async
  {
    String? data = await ApiManager.fetchData('profile/$user/data');
    Map<String,dynamic> profile = json.decode(data!);

    return profile;
  }

}