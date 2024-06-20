import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/bottomMenu.dart';
import 'package:frontend/Screens/Common/bottomMessage.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';

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
      height: (status == FriendshipState.requestRecieved) ? 65 : 30,
      width: 200,
      child: 
        (status == FriendshipState.sameUser) ? 
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 212, 52, 40),
              foregroundColor: Colors.white
            ),
            onPressed: () {
              ShowBottomMenu(context, 'Vuoi disconnetterti?', 
              [
                BottomMenuButton(
                    icon: Icons.logout_rounded, 
                    text: "Sono sicuro", 
                    action: () {
                      AuthService.logout();
                      context.go('/login');
                      ShowBottomMessage(context, 'Ti sei disconnesso');
                    }
                  ),

                  BottomMenuButton(
                    icon: Icons.arrow_back_rounded, 
                    text: "Annulla", 
                    action: (){}
                  ),
              ]);
            }, 
            child: Text("Logout"))
          :
          (status == FriendshipState.requestRecieved) ?
            Column(
              children:[
                SizedBox(
                  height: 30,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      ApiManager.postData('friends/accept', {'username': widget.username})
                        .then((value){
                          widget.onTap();
                          ShowBottomMessage(context, 'Hai un nuovo amico!');
                        }
                        );
                    },
                    child: Text('Accetta amicizia')
                  ),
                ),
                
                SizedBox(height: 5),

                SizedBox(
                  height: 30,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      ApiManager.postData('friends/reject', {'username': widget.username})
                        .then((value){
                          widget.onTap();
                          ShowBottomMessage(context, 'Richiesta rifiutata');
                        }
                      );
                    },
                    child: Text('Rifiuta')
                  ),
                ),
              ],
            )
            :
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> frienddata = {
                  'username': widget.username,
                };

                if (status == FriendshipState.friends) {
                  ApiManager.postData('friends/remove', frienddata)
                    .then((value){
                      widget.onTap();
                      ShowBottomMessage(context, 'La vostra amicizia termina qui');
                    });
                }
                else if (status == FriendshipState.requestSent) {
                  ApiManager.postData('friends/undo_request', frienddata)
                    .then((value){
                      widget.onTap();
                      ShowBottomMessage(context, 'Richiesta annullata');
                    });
                } 
                else if (status == FriendshipState.strangers)
                {
                  ApiManager.postData('friends/request', frienddata)
                    .then((value){
                      widget.onTap();
                      ShowBottomMessage(context, 'Richiesta inviata');
                    });
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
