import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TinyProfile extends StatefulWidget
{
  String username;
  String date;

  TinyProfile
  (
    {
      required this.username,
      required this.date,
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
        radius: 20,
        backgroundImage: NetworkImage("https://picsum.photos/200/300"),
      ),
      title: Text(widget.username),
      subtitle: Text(widget.date),
      onTap: () => context.push('/profilo', extra: widget.username),
    );
  }
}