import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Common/bottomMenu.dart';
import 'package:frontend/Screens/Common/bottomMessage.dart';
import 'package:frontend/Screens/Common/emptyState.dart';
import 'package:frontend/Screens/Common/uploadPictures.dart';
import 'package:frontend/Screens/Profile/Components/friendrequest.dart';
import 'package:frontend/Screens/Profile/Components/posts.dart';
import 'package:frontend/Screens/Profile/Components/profiledata.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ProfiloPage extends StatefulWidget {
  
  String username;
  
  ProfiloPage({
    Key? key,
    required this.username
  }
  ) : super(key: key);

  @override
  _ProfiloPage createState() => _ProfiloPage();
}

class _ProfiloPage extends State<ProfiloPage> {
  TextEditingController descriptionTextController = TextEditingController();
  bool isDescriptionTextFieldVisible = false;
  late FocusNode descriptionFocusNode;
  
  @override
  void initState() {
    super.initState();
    descriptionFocusNode = FocusNode();
    descriptionFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    descriptionFocusNode.removeListener(_onFocusChange);
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!descriptionFocusNode.hasFocus) {
      setState(() {
        isDescriptionTextFieldVisible = false;
      });
    }
  }

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
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  EmptyState(
                    icon: Icons.signal_wifi_connected_no_internet_4_rounded,
                    message: 'Errore durante la connessione al server',
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: Text("Riprova"),
                    onPressed: () => setState((){})
                  )
                ],
              )
            );
        
        Map<String,dynamic> userData = snapshot.data![0] as Map<String,dynamic>;
        List<dynamic> userPosts= snapshot.data![1] as List<dynamic>;
        String fullname = (userData['name'] ?? '') + ' ' + (userData['surname'] ?? '');
        
        return Scaffold(
          bottomSheet: isDescriptionTextFieldVisible ? _buildBottomSheet(context) : null,
          appBar: PageTitle(
            title: widget.username,
            actions: [
              Visibility(
                visible: widget.username == AppService.instance.currentUser!.userid,
                child: IconButton(
                  icon: Icon(Icons.info_outline_rounded),
                  onPressed: () {
                    context.push('/info', extra: [widget.username, userData['birthdate']]);
                  },
                )
              )
            ],
          ),
          body: SingleChildScrollView
          (
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Column
                      (
                        children: [
                          InkWell(
                            child: ProfilePic(imagePath: userData['profile_image_url']),
                            onTap: () {
                              if(widget.username != AppService.instance.currentUser!.userid)
                                return;
                              ShowBottomMenu(context, "Modifica foto profilo", 
                              [
                                BottomMenuButton(
                                  icon: Icons.photo_camera_outlined, 
                                  text: "Scatta una foto", 
                                  action: () => PictureUploader.pickImageForProfile(ImageSource.camera)
                                    .then((value) {
                                      setState((){});
                                      ShowBottomMessage(context, 'Immagine del profilo aggiornata');
                                    })
                                ),

                                BottomMenuButton(
                                  icon: Icons.photo_library_outlined, 
                                  text: "Scegli dalla galleria", 
                                  action: () => PictureUploader.pickImageForProfile(ImageSource.gallery)
                                    .then((value) {
                                      setState((){});
                                      ShowBottomMessage(context, 'Immagine del profilo aggiornata');
                                    })
                                ),

                                if((userData['profile_image_url'] as String).isNotEmpty)
                                BottomMenuButton(
                                  icon: Icons.highlight_remove_rounded, 
                                  text: "Rimuovi", 
                                  action: (){
                                    Future.delayed(Durations.short1).then(
                                      (value){
                                      ShowBottomMenu(context, 'Sei sicuro?', 
                                      [
                                        BottomMenuButton(
                                          icon: Icons.highlight_remove_rounded, 
                                          text: "Sono sicuro", 
                                          action: () {
                                            ApiManager.postData('profile/remove/image', {'username':widget.username})
                                              .then((value) {
                                              setState((){});
                                              ShowBottomMessage(context, 'Immagine del profilo rimossa');
                                            });
                                          }
                                        ),

                                        BottomMenuButton(
                                          icon: Icons.arrow_back_rounded, 
                                          text: "Annulla", 
                                          action: (){}
                                        ),
                                      ]);
                                    });
                                  }
                                ),
                              ]);
                            },
                          ),
                          SizedBox(height: 15),
                          Text(
                            fullname,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      
                      Column
                      (
                        children:
                        [
                          ProfileData
                          (
                            posts: userPosts.length,
                            clickable: widget.username == AppService.instance.currentUser!.userid,
                            username: widget.username,
                            friends: userData['friends'],
                            friends_pending: userData['friends_pending'],
                            friends_requests: userData['friends_request'],
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

                  Padding(
                    padding: EdgeInsets.all(20),
                    child:
                      InkWell(
                        child: userData['description'] != null && (userData['description'] as String).isNotEmpty ?
                          Text(userData['description'])
                          :
                          Text(widget.username == AppService.instance.currentUser!.userid ? 
                            'Racconta qualcosa di te...':
                            '',
                            style: TextStyle(
                              fontStyle: FontStyle.italic
                            ),
                          ),
                        
                        onTap: () {
                          if(widget.username != AppService.instance.currentUser!.userid)
                            return;
                          setState(() {
                            descriptionTextController.text = userData['description'] ?? '';
                            isDescriptionTextFieldVisible = true;
                          });
                          descriptionFocusNode.requestFocus();
                        },
                      )
                  ),              
                  //const SizedBox(height: 50),

                  //Divider(height: 4, thickness: 1,),
                  (userData['friends'] as List<dynamic>).contains(AppService.instance.currentUser!.userid) ||
                  widget.username == AppService.instance.currentUser!.userid ?
                    userPosts.isNotEmpty ?
                      PostsGrid(posts: userPosts)
                      :
                      Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: EmptyState(
                          icon: Icons.landscape_rounded,
                          message: 'Ancora nessun post',
                        )
                      )
                    :
                    Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: EmptyState(
                          icon: Icons.connect_without_contact_rounded,
                          message: 'I post sono solo per gli amici',
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
    List<dynamic> allposts = json.decode(data ?? '[]');

    return allposts.reversed.toList();
  }

  Future<Map<String,dynamic>> getUserData(String user) async
  {
    String? data = await ApiManager.fetchData('profile/$user/data');
    Map<String,dynamic> profile = json.decode(data!);

    return profile;
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(16),
      child: Row
      (
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              maxLength: 256,
              minLines: 1,
              maxLines: 3,
              focusNode: descriptionFocusNode,
              controller: descriptionTextController,
              buildCounter: (BuildContext context,
                    {required int currentLength,
                    required bool isFocused,
                    required int? maxLength}) {
                  return Container(height: 0);
                },
              decoration: InputDecoration(
                hintText: 'Scrivi qualcosa...',
                border: OutlineInputBorder(),
              ),
            )
          ),
          
          IconButton(
            icon: Icon(Icons.arrow_forward_rounded),
            onPressed: () {
              ApiManager.postData('profile/edit/description', {'description': descriptionTextController.text.trim()})
              .then((value){
                setState(() {
                  isDescriptionTextFieldVisible = false; // Nascondi il BottomSheet
                  descriptionTextController.clear(); // Pulisci il testo
                });
              });
            },
          ),
        ]       
      )
    );
  }
}