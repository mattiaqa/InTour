import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/profile_data.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileDataAdapter());
  await Hive.openBox('App Service Box');
  AppService.instance.initialize();
  MapboxOptions.setAccessToken(
    'pk.eyJ1IjoibWF0dGlhcWEiLCJhIjoiY2x3cGR6ODVmMmVraDJrcGZzbWtxaGMybSJ9.ErjayNg2Wifmh_nEmpkZwg',
  );

  runApp(MyApp());
  usePathUrlStrategy();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        // ...
      ),
    );
  }
}