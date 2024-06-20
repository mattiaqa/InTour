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
    ImageProvider imageProvider;
    if(imagePath.isNotEmpty)
      imageProvider = NetworkImage("http://$myIP:8000/api" + imagePath);
    else
      imageProvider = AssetImage('assets/images/no_profile_pic.png');

    return CircleAvatar
    (
      radius: radius,
      backgroundImage: imageProvider
    );
  }
}