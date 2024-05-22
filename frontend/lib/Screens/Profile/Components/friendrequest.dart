import 'package:flutter/material.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';

enum FriendshipState {
  sameUser,
  strangers,
  requestSent,
  requestRecieved,
  friends
}

// ignore: must_be_immutable
class FirendRequestButton extends StatefulWidget {
  String username;
  List<dynamic> friends;
  List<dynamic> friends_pending;
  List<dynamic> friends_request;
  VoidCallback onTap;

  FirendRequestButton({
    super.key, 
    required this.username,
    required this.friends,
    required this.friends_pending,
    required this.friends_request,
    required this.onTap
  });

  @override
  FriendRequestButtonState createState() => FriendRequestButtonState();
}

class FriendRequestButtonState extends State<FirendRequestButton> {
  late FriendshipState status;

  @override
  void initState() {
    status = friendStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox
    (
      height: 30,
      width: 200,
      child: (status == FriendshipState.sameUser)
          ? ElevatedButton(onPressed: () {}, child: Text("Modifica"))
          : ElevatedButton(
              onPressed: () {
                Map<String, dynamic> frienddata = {
                  'username': widget.username,
                };

                if (status == FriendshipState.friends) {
                  ApiManager.postData('friends/remove', frienddata)
                      .then((value) => widget.onTap());
                }
                else if (status == FriendshipState.requestRecieved) {
                  ApiManager.postData('friends/accept', frienddata)
                      .then((value) => widget.onTap());
                } 
                else if (status == FriendshipState.requestSent) {

                } 
                else if (status == FriendshipState.strangers)
                {
                  ApiManager.postData('friends/request', frienddata)
                      .then((value) => widget.onTap());
                }
              },
              child: Text(buttonText(status))
            )
    );
  }

  FriendshipState friendStatus()
  {
    String currentUser = AppService.instance.currentUser!.userid!;

    if ((widget.username == currentUser))
      return FriendshipState.sameUser;
    
    if (widget.friends.contains(currentUser)) 
      return FriendshipState.friends;
    
    if (widget.friends_request.contains(currentUser))
      return FriendshipState.requestSent;
    
    if (widget.friends_pending.contains(currentUser))
      return FriendshipState.requestRecieved;
    
    return FriendshipState.strangers;
  }

  String buttonText(FriendshipState status)
  {
    switch (status) {
      case FriendshipState.friends:
        return "Rimuovi amicizia";
      case FriendshipState.requestRecieved:
        return "Accetta amicizia";
      case FriendshipState.requestSent:
        return "Richiesta iniviata";
      case FriendshipState.strangers:
        return "Aggiungi amico";
      default:
        return "Errore";
    }
  }
}
