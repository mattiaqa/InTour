import 'package:flutter/material.dart';

class PercorsoTile extends StatelessWidget 
{
  String? title;
  String? category;
  String? startpoint;

  void Function()? onTap;

  PercorsoTile
  ({
    required this.title,
    required this.category,
    required this.startpoint,
    this.onTap,
  });

  factory PercorsoTile.fromJson(Map<String, dynamic> json)
  {
    return PercorsoTile
    (
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startpoint: json['startpoint'] ?? '',
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
        title: Text(title!),
        subtitle: Text
        (
          '$startpoint\n$category',
        ),
        onTap: onTap,
      ),
    );
  }
}