import 'package:flutter/material.dart';
import 'package:frontend/Screens/Bacheca/bacheca.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/Profilo/profilo.dart';
import 'package:go_router/go_router.dart';

final pages = [Percorsi(), Bacheca(), const ProfiloPage()];

class PageBorders extends StatefulWidget {
  const PageBorders({
    super.key,
    /*required this.child*/
  });
  static const route = '/home';
  @override
  State<PageBorders> createState() => PageBordersState();
}

class PageBordersState extends State<PageBorders> {
  String pageName = 'InTour';
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
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
            NavigationDestination(label: 'Bacheca', icon: Icon(Icons.home)),
            NavigationDestination(
                label: 'Profilo', icon: Icon(Icons.account_circle_rounded)),
          ]),

      /*body: Stack
      (
        children: 
        [
          widget.child,
          Positioned
          (
            bottom: 0,
            child: BottomNavigationBar
            (
              currentIndex: selectedIndex,
              onTap: (value)
              {
                switch(value)
                {
                  case 0:
                  {
                    setState(() {
                      pageName = 'Bacheca';
                      selectedIndex = 0;
                    });
                    contexto.go('/bacheca');
                    break;
                  }
                  case 1:
                  {
                    setState(() {
                      pageName = 'Percorsi';
                      selectedIndex = 1;
                    });
                    contexto.go('/percorsi');
                    break;
                  } 
                }  
              },
              items: const 
              [
                BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings)),
              ]
            )
          ),
        ],
      )*/
    );
  }
}
