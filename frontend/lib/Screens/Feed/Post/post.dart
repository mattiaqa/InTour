import 'package:flutter/material.dart';
import 'package:frontend/Screens/Feed/Post/Components/Comments/tile.dart';
import 'package:frontend/Screens/Feed/Post/Components/like.dart';
import 'package:frontend/Screens/Feed/Post/Components/user.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BachecaTile extends StatefulWidget {
  String id;
  String? username;
  String? date;
  String? description;
  String imagePath;
  List<dynamic>? comments;
  List<dynamic>? likers;

  BachecaTile
  ({
    required this.id,
    required this.username,
    required this.date,
    required this.imagePath,
    this.description,
    this.comments,
    this.likers,
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
      margin: EdgeInsets.all(8.0),
      //color: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          TinyProfile
          (
            username: widget.username!,
            date: formatDateToRelative(widget.date!),
          ),
          Container //SizedBox
          (
            //height: 300,
            //width: 300,
            child: Image.network("http://$myIP:8000/api" + widget.imagePath),
          ),
          SizedBox(height: 8,),
          Row
          (
            children:
            [
              Expanded
              (
                child: Row
                (
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children:
                  [
                    InkWell
                    (
                      child: LikeButton
                      (
                        liked: liked,
                        postId: widget.id,
                      ),
                      onTap: () {
                        setState(() {
                          likecount += liked ? -1 : 1;
                          liked = !liked;
                        });
                      },
                    ),
                    
                    const VerticalDivider
                    (
                      width: 20,
                    ),
                    InkWell
                    (
                      child: const Icon
                      (
                        Icons.comment_outlined,
                        size: 40,
                      ),
                      onTap: () 
                      {
                        context.push('/comments', extra: widget.comments);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          Text
          (
            likecount.toString() + ' Mi piace', 
            style: TextStyle
            (
              fontWeight: FontWeight.w600
            ),
          ),
          Text("${widget.description}"),
          Divider(height: 20, thickness: 0.4,)
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

}
