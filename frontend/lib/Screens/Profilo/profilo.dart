import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/Screens/Profilo/widget/galleria.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/profile_data.dart';
import 'package:frontend/Screens/Profilo/widget/profiloHeaders.dart';
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

          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text(
                    nome,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout_rounded),
                      onPressed: () {
                        AuthService.logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 18.0, right: 18.0, bottom: 20, top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://picsum.photos/200/300"),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            snapshot.data!.length.toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "Post",
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
                                            AppService.instance.currentUser
                                                    ?.friends?.length
                                                    .toString() ??
                                                "0",
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
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                      height: 30,
                                      width: 200,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text("Modifica")))
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
                                //image: NetworkImage('https://picsum.photos/350/350'),
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
              )));
        });
  }
}

Future<List<dynamic>> getPosts() async {
  String? data = await ApiManager.fetchData('profile/posts');
  List<dynamic> allposts = json.decode(data!);

  return allposts;
}
