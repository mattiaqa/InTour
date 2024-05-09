import 'package:flutter/material.dart';
import 'package:frontend/Screens/Login/login.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/borders.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/profile_data.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileDataAdapter());
  await Hive.openBox('App Service Box');
  AppService.instance.initialize();
  runApp(MyApp());
  usePathUrlStrategy();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
