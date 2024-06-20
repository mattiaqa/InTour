import 'package:flutter/material.dart';
import 'package:frontend/Screens/Feed/Post/post.dart';
import 'package:frontend/utils/constants.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class PostsGrid extends StatelessWidget
{
  List<dynamic> posts;

  PostsGrid({
    required this.posts
  });

  @override
  Widget build(BuildContext context)
  {
    return GridView.count(
      physics: ScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      shrinkWrap: true,
      children: List.generate(
        posts.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: InkWell
            (
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('http://$myIP:8000/api' +
                        posts[index]["img_url"]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
              ),

              onTap: () {
                BachecaTile tile = BachecaTile(
                  id: posts[index]['_id'],
                  username: posts[index]['creator'],
                  date: posts[index]['date'], 
                  imagePath: posts[index]['img_url'],
                  description: posts[index]['description'],
                  likers: posts[index]['like'],
                  comments: posts[index]['comments'],
                  clickable: false,
                );
                context.push('/post', extra: tile);
              }
            ) 
            
          );
        },
      ),
    );
  }
}