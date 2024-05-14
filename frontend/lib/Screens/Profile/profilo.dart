import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Profile/Components/profiledata.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/profile_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/utils/constants.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({Key? key}) : super(key: key);

  @override
  _ProfiloPage createState() => _ProfiloPage();
}

class _ProfiloPage extends State<ProfiloPage> {
  String nome = AppService.instance.currentUser?.userid ?? 'User';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Mostra un indicatore di caricamento mentre si ottengono le SharedPreferences
          }

          if (snapshot.hasError) {
            return Text(
                'Errore durante il recupero dei post: ${snapshot.error}');
          }
          
          return Scaffold
          (
            appBar: PageTitle
            (
              title: nome,
              actions: 
              [
                IconButton
                (
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () 
                  {
                    AuthService.logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
            body: SingleChildScrollView
            (
              child: Padding
              (
                padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                child: Column
                (
                  children: 
                  [
                    Row
                    (
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: 
                      [
                        ProfilePic(imagePath: "https://picsum.photos/200/300"),

                        Column
                        (
                          children: 
                          [
                            ProfileData
                            (
                              posts: snapshot.data!.length, 
                              friends: AppService.instance.currentUser!.friends!.length
                            ),

                            SizedBox(height: 20),

                            SizedBox
                            (
                              height: 30,
                              width: 200,
                              child: ElevatedButton
                              (
                                onPressed: () {},
                                child: Text("Modifica")
                              )
                            )
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 50),

                    GridView.count(
                      physics: ScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      shrinkWrap: true,
                      children: List.generate(
                        snapshot.data!.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage('http://$myIP:8000/api' +
                                      snapshot.data![index]["img_url"]),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0.0),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
              ));
      });
  }
}

Future<List<dynamic>> getPosts() async {
  String? data = await ApiManager.fetchData('profile/posts');
  List<dynamic> allposts = json.decode(data!);


  return allposts;
}