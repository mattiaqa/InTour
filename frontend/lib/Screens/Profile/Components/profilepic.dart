import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';

// ignore: must_be_immutable
class ProfilePic extends StatelessWidget
{
  String imagePath;
  double radius;
  ProfilePic
  (
    {
      super.key,
      required this.imagePath,
      this.radius = 40
    }
  );

  @override
  Widget build(BuildContext context)
  {
    return CircleAvatar
    (
      radius: radius,
      backgroundImage: NetworkImage("http://$myIP:8000/api" + imagePath),
    );
  }
}