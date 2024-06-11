import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class ProfileData extends StatelessWidget
{
  int posts;
  //int? friends;
  bool clickable;
  List<dynamic> friends;
  List<dynamic>? friends_requests;
  List<dynamic>? friends_pending;
  String username;

  ProfileData
  (
    {
      super.key,
      required this.posts,
      required this.clickable,
      required this.friends,
      this.friends_requests,
      this.friends_pending,
      required this.username
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

        SizedBox(width: 30),

        InkWell
        (
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  Text(
                    friends.length.toString(),
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

              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: clickable && friends_requests!.isNotEmpty ? 
                      Colors.red :
                      Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          
          onTap: ()
          {
            if(clickable)
            {
              /*List<List<dynamic>> data = List.from([
                friends, 
                friends_pending,
                friends_requests
              ]); */
              context.push('/friends', extra: username);
            }
          },
        )
        
      ],
    );
  }
}