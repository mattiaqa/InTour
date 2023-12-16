import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Profilo/profilo.dart';

Widget profileHeaderWidget(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(color: Colors.white),
    child: Padding(
      padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff74EDED),
                backgroundImage:
                    NetworkImage("https://placeimg.com/640/480/people"),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "23",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Posts",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0.4,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        "1.5M",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Amici",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: const Text(
              "Descrizione",
              style: TextStyle(
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}
