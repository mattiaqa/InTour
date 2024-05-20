import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Feed/feed.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/Profile/profilo.dart';
import 'package:frontend/Screens/Share/share.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:go_router/go_router.dart';

var pages = 
[
  Percorsi(), 
  Bacheca(), 
  SharePage(), 
  ProfiloPage(username: AppService.instance.currentUser!.userid!,)
];

class PageBorders extends StatefulWidget {
  int ? selectedIndex;
  String ? username;
  
  PageBorders({
    super.key,
    this.selectedIndex,
    this.username
  });
  static const route = '/home';
  @override
  State<PageBorders> createState() => PageBordersState();
}

class PageBordersState extends State<PageBorders> {
  String pageName = 'InTour';
  late int selectedIndex;
  bool? friendrequest;

  @override
  void initState() {
    selectedIndex = widget.selectedIndex ?? 0;
    pages[3] = (widget.username == null) ? 
      ProfiloPage(username: AppService.instance.currentUser!.userid!) :
      ProfiloPage(username: widget.username!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>
    (
      future: _hasFriendResquests(),
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) 
        {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Placeholder while loading
        } 
        
        if (snapshot.hasError) 
        {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 
        return Scaffold(
          //appBar: AppBar(title: Text(pageName)),
          body: pages[selectedIndex],
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedIndex: selectedIndex,
            destinations: [
              NavigationDestination(
                  label: 'Percorsi', icon: Icon(Icons.navigation_rounded)),
              NavigationDestination(
                label: 'Bacheca', icon: Icon(Icons.home)),
              NavigationDestination(
                  label: 'Pubblica', icon: Icon(Icons.photo_camera_back_outlined)),
              NavigationDestination(
                  label: 'Profilo', 
                  icon: Stack
                  (
                    alignment: Alignment.topRight,
                    children: [
                      Icon(Icons.account_circle_rounded),
                      Container(
                        padding: EdgeInsets.all(1), // Aumentato il padding per rendere il badge più visibile
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: snapshot.data! ? Colors.red : Colors.transparent
                        ),
                        child: Text( // Aggiunto testo per rendere il badge visibile
                          ' ', 
                          style: TextStyle(
                            color: Colors.transparent, // Testo trasparente per non essere visibile
                          ),
                        ),
                        width: 10, // Aggiunta la larghezza per rendere il badge visibile
                        height: 10, // Aggiunta l'altezza per rendere il badge visibile
                      ),
                    ],
                  ),
                ),
            ]
          ),
        );
      }
    );
  }

  Future<bool> _hasFriendResquests() async
  {
    String user = AppService.instance.currentUser!.userid!;
    String? data = await ApiManager.fetchData('profile/$user/data');

    Map<String,dynamic> profile = json.decode(data!);

    if(profile['friends_request'] != null)
    {
      List<dynamic> friends_to_choose = profile['friends_request'] as List<dynamic>;
      return !friends_to_choose.isEmpty;
    }

    return false;
  }
}
