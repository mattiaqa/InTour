import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/emptyState.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class TinyProfile extends StatefulWidget
{
  String username;
  String? date;
  String? image;
  bool clickable;

  TinyProfile
  (
    {
      required this.username,
      this.date,
      this.image,
      this.clickable = true,
    }
  );

  @override
  State<TinyProfile> createState() => TinyProfileState();
}

class TinyProfileState extends State<TinyProfile>
{
  @override
  Widget build(BuildContext context)
  {
    return ListTile
    (
      titleAlignment: ListTileTitleAlignment.top,
      leading: widget.image != null ?
        ProfilePic(
          imagePath: widget.image!,
          radius: 20,
        )
        :
        FutureBuilder(
          future: _getpfp(), 
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator(); // Placeholder while loading
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
                      child: Text("RIPROVA"),
                      onPressed: () => setState((){})
                    )
                  ],
                )
              );
          
            return ProfilePic(
              imagePath: snapshot.data!,
              radius: 20,
            );
          }
        ),
       
      title: Text(widget.username),
      subtitle: widget.date != null ? Text(widget.date!) : null,
      
      onTap: (widget.username != AppService.instance.currentUser!.userid && widget.clickable) ? 
      () => context.push('/profilo', extra: widget.username)
      :
      null,
    );
  }

  Future<String> _getpfp() async
  {
    String profilepic = (await ApiManager.fetchData("profile/${widget.username}/profile_image"))!;
    profilepic = json.decode(profilepic)['profile_image_url'];
    return profilepic;
  }
}