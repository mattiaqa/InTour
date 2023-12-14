import 'package:flutter/material.dart';
import 'package:frontend/Screens/Bacheca/commento_tile.dart';
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
          Text(username!),
          const SizedBox
          (
            height: 300,
            width: 300,
            child: Image
            (
              image:AssetImage("assets/images/Placeholder_view_vector.svg.png"),
            ),
          ),
          Row
          (
            children: 
            [
              Text(date!),
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
                        const Icon
                        (
                          Icons.favorite_border, 
                          size: 40,
                        ),
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
                            //context.go('/comments');
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

          Divider(height: 20, thickness: 0,),

          Text(description!),
        ],
      )
    );
  }
}