import 'package:flutter/material.dart';
import 'package:frontend/Screens/Feed/feed.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/Profile/profilo.dart';
import 'package:frontend/Screens/Share/share.dart';
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
        destinations: const [
          NavigationDestination(
              label: 'Percorsi', icon: Icon(Icons.navigation_rounded)),
          NavigationDestination(
            label: 'Bacheca', icon: Icon(Icons.home)),
          NavigationDestination(
              label: 'Pubblica', icon: Icon(Icons.photo_camera_back_outlined)),
          NavigationDestination(
              label: 'Profilo', icon: Icon(Icons.account_circle_rounded)),
        ]
      ),
    );
  }
}
