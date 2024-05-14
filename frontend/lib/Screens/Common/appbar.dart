import 'package:flutter/material.dart';

class PageTitle extends StatefulWidget implements PreferredSizeWidget
{
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  String title;
  List<Widget> ? actions;

  PageTitle
  (
    {
      super.key,
      this.title = '',
      this.actions
    }
  );

  PageTitleState createState() => PageTitleState();
}

class PageTitleState extends State<PageTitle> 
{
  @override
  Widget build(BuildContext context)
  {
    return PreferredSize
    (
      preferredSize: Size.fromHeight(50), 
      child: AppBar
      (
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w600),
        ),
        actions: widget.actions
      )
    );
  }
}