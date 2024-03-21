import 'package:flutter/material.dart';

class TinyProfile extends StatefulWidget
{
  String username;
  String? description;

  TinyProfile
  (
    {
      required this.username,
      this.description,
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
      leading: const CircleAvatar
      (
        radius: 28,
        backgroundImage: AssetImage('assets/images/no_profile_pic.png'),
      ),
      title: Text(widget.username),
      subtitle: Text(widget.description ??= ''),
    );
  }
}