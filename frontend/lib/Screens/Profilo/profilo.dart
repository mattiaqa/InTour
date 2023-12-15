import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/Screens/Profilo/widget/galleria.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/profile_data.dart';
import 'package:frontend/Screens/Profilo/widget/profiloHeaders.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({Key? key}) : super(key: key);

  @override
  _ProfiloPage createState() => _ProfiloPage();
}

class _ProfiloPage extends State<ProfiloPage> {
  String nome = AppService.instance.currentUser?.name ?? 'Error 404';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey),
            )),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                nome,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_box_outlined,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
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
                /*Expanded(
                    child: TabBarView(
                  children: [
                    Gallery(),
                  ],
                ))*/
              ],
            )));
  }
}
