import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utils/app_service.dart';

class ProfileData extends StatelessWidget
{
  int posts;
  int? friends;

  ProfileData
  (
    {
      super.key,
      required this.posts,
      this.friends
    }
  );

  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: [
        Column(
          children: [
            Text(
              posts.toString(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Post",
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 0.4,
              ),
            )
          ],
        ),

        Visibility
        (
          visible: friends != null,
          child: SizedBox(
            width: 30,
          )
        ),

        Visibility
        (
          visible: friends != null,
          child: Column(
            children: [
              Text(
                friends.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Amici",
                style: TextStyle(
                  letterSpacing: 0.4,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}