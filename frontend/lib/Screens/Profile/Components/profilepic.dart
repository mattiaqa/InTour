import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfilePic extends StatelessWidget
{
  String imagePath;
  ProfilePic
  (
    {
      super.key,
      required this.imagePath,
    }
  );

  @override
  Widget build(BuildContext context)
  {
    return CircleAvatar
    (
      radius: 40,
      backgroundImage: NetworkImage(
          imagePath),
    );
  }
}