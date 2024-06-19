import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/bottomMenu.dart';
import 'package:frontend/Screens/Feed/Post/Components/like.dart';
import 'package:frontend/Screens/Feed/Post/Components/user.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BachecaTile extends StatefulWidget {
  String id;
  String? username;
  String? userimage;
  String? date;
  String? description;
  String imagePath;
  List<dynamic>? comments;
  List<dynamic>? likers;
  bool clickable;

  BachecaTile
  ({
    required this.id,
    required this.username,
    required this.date,
    required this.imagePath,
    this.userimage,
    this.description,
    this.comments,
    this.likers,
    this.clickable = true,
  });

  BachecaTileState createState() => BachecaTileState();
}

class BachecaTileState extends State<BachecaTile>
{
  late bool liked;
  late int likecount;

  @override
  void initState() {
    liked = widget.likers!.contains(AppService.instance.currentUser!.userid);
    likecount =  widget.likers!.length;
    super.initState();
  }
  @override
  Widget build(BuildContext context) 
  {
    return Card
    (
      elevation: 0,
      margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 2.0),
      //color: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          TinyProfile(
            username: widget.username!,
            date: formatDateToRelative(widget.date!),
            image: widget.userimage,
            clickable: widget.clickable
          ),
          
          Center(
            child: Container(
              child: Image.network("http://$myIP:8000/api" + widget.imagePath),
            )
          ),
          
          
          SizedBox(height: 8),
          
         
          Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Visibility(
                visible: widget.username != AppService.instance.currentUser!.userid,
                child: LikeButton(
                  liked: liked,
                  postId: widget.id,
                  onTap: () 
                  {
                    setState(() {
                      likecount += liked ? -1 : 1;
                      liked = !liked;
                    });
                  }
                ),
              ),
               
              VerticalDivider(
                width: (widget.username != AppService.instance.currentUser!.userid) ? 15 : 0,
              ),

              InkWell(
                child: const Icon(
                  Icons.comment_outlined,
                  size: 40,
                ),
                onTap: () => context.push('/comments', extra: [widget.id, widget.comments, widget.username])
              ),

              // Spacer
              Spacer(),
              Visibility(
                visible: widget.username == AppService.instance.currentUser!.userid,
                child: InkWell(
                  child: const Icon(
                    Icons.delete_forever_outlined,
                    size: 40,
                  ),
                  onTap: () {
                    ShowBottomMenu(context, "Elimina post", 
                      [
                        BottomMenuButton(
                          icon: Icons.check, 
                          text: "Sono sicuro", 
                          action: () async {
                            Map<String, dynamic> data = {
                              'post_id': widget.id,
                            };
                            ApiManager.postData('post/delete', data).then(
                              (value) => context.pop()
                            );
                          }
                        ),

                        BottomMenuButton(
                          icon: Icons.arrow_back_rounded, 
                          text: "Annulla", 
                          action: (){}
                        ),
                      ]
                    );
                  },
                ),
              ),
              
            ],
          ),
          
          SizedBox(height: 5),

          Text(
            likecount.toString() + ' Devo andarci', 
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          Visibility(
            visible: splitAtFirstOccurrence(widget.description!, '\n')[0].isNotEmpty,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  "${splitAtFirstOccurrence(widget.description!, '\n')[0]}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: splitAtFirstOccurrence(widget.description!, '\n')[1].isNotEmpty,
            child: Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                //color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${splitAtFirstOccurrence(widget.description!, '\n')[1]}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          Divider(height: 20, thickness: 0.4)
        ],
      )
    );
  }

  String formatDateToRelative(String dateString) 
  {
    DateTime date = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    
    // Verifica se la data è oggi
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Oggi';
    }

    // Verifica se la data è ieri
    DateTime yesterday = now.subtract(Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Ieri';
    }

    // Verifica se la data è nel mese corrente
    if (date.year == now.year && date.month == now.month) {
      int difference = now.day - date.day;
      return '$difference giorni fa';
    }

    // Se la data non è oggi, ieri o questo mese, restituisci la data formattata
    return DateFormat('dd/MM/yyyy').format(date);
  }

  List<String> splitAtFirstOccurrence(String input, String delimiter) {
  int index = input.indexOf(delimiter);
  if (index == -1) {
    return [input];
  }
  String firstPart = input.substring(0, index);
  String secondPart = input.substring(index + delimiter.length);
  return [firstPart, secondPart];
}
}
