import 'package:flutter/material.dart';

void ShowBottomMenu(BuildContext context, String title, List<BottomMenuButton> buttons)
{
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext contextparam) {
      return Container(
        height: 220,
        color: Color.fromARGB(255, 209, 241, 194),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [
            Container
            (
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide()
                )
              ),
              child:  Padding
              (
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text
                (
                  title,
                  style: TextStyle
                  (
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons,
              ),
            ),
            Spacer(),
          ],
        ) 
      );
    },
  );
}

class BottomMenuButton extends StatelessWidget
{
  final IconData icon;
  final String text;
  final VoidCallback action;

  BottomMenuButton({
    required this.icon,
    required this.text,
    required this.action
  });

  @override
  Widget build(BuildContext context)
  {
    return Column
    (
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: 
      [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3)
            //color: Colors.blue, // Colore di sfondo
          ),
          child: IconButton(
            icon: Icon(icon),
            iconSize: 40,
            padding: EdgeInsets.all(30),
            //color: Colors.white, // Colore dell'icona
            onPressed: () => action(), // Funzione di callback
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle
          (
            fontWeight: FontWeight.w700
          ),
        )
      ],
    );
  }
}