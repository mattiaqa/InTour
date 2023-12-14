import 'package:flutter/material.dart';
import 'package:frontend/Screens/borders.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/routes.dart';

void main() 
{
  runApp(MyApp());
  usePathUrlStrategy();
}


class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp.router
    (
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

/*
class _MyAppState extends State<MyApp>
{
  @override
  void initState() {
    super.initState();

    usePathUrlStrategy();
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp.router
    (
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      //builder: (context, child) => PageBorders(child: child!)
    );
  }
}
*/
