import 'package:flutter/material.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class TinyProfile extends StatefulWidget
{
  String username;
  String date;
  String image;

  TinyProfile
  (
    {
      required this.username,
      required this.date,
      required this.image
    }
  );

  @override
  State<TinyProfile> createState() => TinyProfileState();
}

class TinyProfileState extends State<TinyProfile>
{
  @override
  Widget build(BuildContext context)
  {
    return ListTile
    (
      leading: ProfilePic
      (
        imagePath: widget.image,
        radius: 20,
      ),
      title: Text(widget.username),
      subtitle: Text(widget.date),
      onTap: () => context.push('/profilo', extra: widget.username),
    );
  }
}