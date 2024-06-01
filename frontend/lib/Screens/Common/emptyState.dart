import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget
{
  IconData? icon;
  String message;

  EmptyState({
    this.icon,
    this.message = '',
  });

  @override
  Widget build(BuildContext context)
  {
    return Center
    (
      child: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      )
    );
  }
}