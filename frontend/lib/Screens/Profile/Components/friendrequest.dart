import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';

class FirendRequestButton extends StatefulWidget
{
  String username;
  FirendRequestButton
  (
    {
      super.key,
      required this.username
    }
  );

  @override
  FriendRequestButtonState createState() => FriendRequestButtonState();
}

class FriendRequestButtonState extends State<FirendRequestButton>
{
  @override
  Widget build(BuildContext context)
  {
    return SizedBox
    (
      height: 30,
      width: 200,
      child: (widget.username == AppService.instance.currentUser!.userid) ? 
        ElevatedButton
        (
          onPressed: () {},
          child: Text("Modifica")
        )
        :
        ElevatedButton
        (
          onPressed: () 
          {
            Map<String, dynamic> frienddata = {
              'username': widget.username,
            };

            if(areFriends())
            {  
              ApiManager.postData('friends/remove', frienddata).then
              (
                (value)
                {
                  setState(() {
                    
                  });
                }
              );
            }
            else
            {
              ApiManager.postData('friends/add', frienddata).then((value) => setState(() {
                
              }));
            }
          },
          child: areFriends() ? 
            Text("Rimuovi amicizia")
            :
            Text("Richiesta amico")
        )
    );
  }

  bool areFriends()
  {
    if(AppService.instance.currentUser!.friends == null)
      return false;

    return AppService.instance.currentUser!.friends!.contains(widget.username);
  }
}