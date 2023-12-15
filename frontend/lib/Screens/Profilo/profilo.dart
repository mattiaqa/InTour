import 'package:flutter/material.dart';
import 'package:frontend/Screens/Profilo/widget/galleria.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/Screens/Profilo/widget/profiloHeaders.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({Key? key}) : super(key: key);

  @override
  _ProfiloPage createState() => _ProfiloPage();
}

class _ProfiloPage extends State<ProfiloPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey),
            )),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                "Nome",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_box_outlined,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mode_edit,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        ),
        body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                profileHeaderWidget(context),
                Expanded(
                    child: TabBarView(
                  children: [
                    Gallery(),
                  ],
                ))
              ],
            )));
  }
}
