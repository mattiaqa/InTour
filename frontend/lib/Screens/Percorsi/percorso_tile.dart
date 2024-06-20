import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';

// ignore: must_be_immutable
class PercorsoTile extends StatelessWidget {
  String? title;
  String? category;
  String? startpoint;
  String? imageName;

  void Function()? onTap;

  PercorsoTile({
    required this.title,
    required this.category,
    required this.startpoint,
    required this.imageName,
    this.onTap,
  });

  factory PercorsoTile.fromJson(Map<String, dynamic> json) {
    return PercorsoTile(
        title: json['title'] ?? '',
        category: json['category'] ?? '',
        startpoint: json['startpoint'] ?? '',
        imageName: json['imageName'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  "http://$myIP:8000/api/uploads/trails/${imageName}",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                startpoint!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
