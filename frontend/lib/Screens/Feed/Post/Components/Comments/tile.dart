import 'package:flutter/material.dart';
import 'package:frontend/Screens/Feed/Post/Components/user.dart';

class CommentoTile extends StatelessWidget {
  final String user;
  final String text;
  final String commentId;

  CommentoTile({
    required this.user,
    required this.text,
    required this.commentId,
  });

  factory CommentoTile.fromJson(Map<String, dynamic> json) {
    return CommentoTile(
      user: json['user'] ?? '',
      text: json['comment'] ?? '',
      commentId: json['commentId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8.0),
        color: Color.fromARGB(255, 242, 239, 239),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TinyProfile(
          username: user,
          date: text,
          clickable: false,
        )

        /*ListTile
      (
        isThreeLine: true,
        title: Text(user!),
        subtitle: Text(text!),
        onTap: onTap,
      ),*/
        );
  }
}
