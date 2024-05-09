import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Profilo/profilo.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';

Widget profileHeaderWidget(BuildContext context) 
{
  return FutureBuilder<int>
  (
    future: _getPosts(),
    builder: (context, snapshot) 
    {
      if (snapshot.connectionState == ConnectionState.waiting)
      {
        return CircularProgressIndicator(); // Mostra un indicatore di caricamento mentre si ottengono le SharedPreferences
      }

      if (snapshot.hasError)
      {
        return Text('Errore durante il recupero delle SharedPreferences: ${snapshot.error}');
      }

      return Container
      (
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding
        (
          padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              const SizedBox
              (
                height: 10,
              ),
              
              Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  CircleAvatar
                  (
                    radius: 40,
                    backgroundImage: NetworkImage("https://picsum.photos/200/300"),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            snapshot.data.toString(),
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
                            AppService.instance.currentUser?.friends?.length.toString() ?? "0",
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
    },
  );
}

Future<int> _getPosts() async
{
  String? data = await ApiManager.fetchData('profile/posts');
  List<dynamic> allposts = json.decode(data!);
  
  return allposts.length; 
}
