import 'package:flutter/material.dart';
import 'package:frontend/Screens/Bacheca/commento_tile.dart';
import 'package:frontend/Screens/Bacheca/like_icon.dart';
import 'package:frontend/Screens/Bacheca/profilo_nome_foto.dart';
import 'package:frontend/utils/constants.dart';
import 'package:go_router/go_router.dart';

class BachecaTile extends StatelessWidget 
{
  String? username;
  String? date;
  String? description;
  String imagePath;
  List<CommentoTile>? comments;
  int? likes;

  void Function()? onTap;

  BachecaTile
  ({
    required this.username,
    required this.date,
    required this.imagePath,
    this.description,
    this.comments,
    this.likes,

    this.onTap,
  });

  factory BachecaTile.fromJson(Map<String, dynamic> json)
  {
    List<dynamic> commentiJson = json['comments'];

    List<CommentoTile> commentiList = [];
    for (var item in commentiJson) {
      commentiList.add(CommentoTile.fromJson(item));
    }

    return BachecaTile
    (
      username: json['creator'] ?? '',
      date: json['date'] ?? '',
      imagePath: json['img_url'] ?? '',
      description: json['description'] ?? '',
      comments: commentiList,
      likes: json['like'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Card
    (
      margin: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 242, 239, 239),
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column
      (
        children: 
        [
          
          Container//SizedBox
          (
            //height: 300,
            //width: 300,
            child: Image.network
            (
              "http://$myIP:8000" + imagePath
              //image:AssetImage("assets/images/Placeholder_view_vector.svg.png"),
            ),
          ),
          
          TinyProfile(username: username!, description: description,),
          
          Row
          (
            children: 
            [
              Text("\t\t\t$date"),
              
              Expanded
              (
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: 
                  [
                    Column
                    (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
                        LikeButton(liked: true),
                        Text(likes.toString())
                      ]
                    ),

                    const VerticalDivider(width: 20,),

                    Column
                    (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
                        InkWell
                        (
                          child: const Icon
                          (
                            Icons.comment, 
                            size: 40,
                          ),
                          onTap: () {
                            context.push('/comments', extra: comments);
                          },
                        ),
                        
                        Text(comments!.length.toString())
                      ]
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}