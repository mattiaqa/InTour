import 'package:flutter/material.dart';

class CommentoTile extends StatelessWidget 
{
  final String? user;
  final String? text;
  final void Function()? onTap;

  CommentoTile
  ({
    required this.user,
    required this.text,

    this.onTap,
  });

  factory CommentoTile.fromJson(Map<String, dynamic> json)
  {
    return CommentoTile
    (
      user: json['user'] ?? '',
      text: json['comment'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Card
    (
      margin: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 242, 239, 239),
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile
      (
        isThreeLine: true,
        title: Text(user!),
        subtitle: Text(text!),
        onTap: onTap,
      ),
    );
  }
}