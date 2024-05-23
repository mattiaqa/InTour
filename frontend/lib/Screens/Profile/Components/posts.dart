import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';

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
          );
        },
      ),
    );
  }
}