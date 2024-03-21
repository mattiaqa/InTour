import 'package:flutter/material.dart';
import 'package:frontend/Screens/borders.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/profile_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileDataAdapter());
  await Hive.openBox('App Service Box');
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


/*
import 'package:flutter/material.dart';
//Shohel Rana Shanto

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:4 ,
      child: Scaffold(
        body: NestedScrollView(headerSliverBuilder: (context,_){
          return [
            SliverAppBar(
              pinned: true,
              title: Text('Sliver TabBar'),
              backgroundColor: Colors.black87,
              bottom: TabBar(tabs: [
                Tab(text: 'Grid',),
                Tab(text: 'List',),
                Tab(text: 'Images',),
                Tab(text: 'Color',),
              ]),
            )
          ];
        },
        
         body: TabBarView(children: [
           Container(color: Colors.green,child: GridView.count(crossAxisCount: 3,
           children: 
             List.generate(100, (index) => 
             Card(color: Colors.amber,child: Text('Grid$index'),)
             )
           
           
           ),),
           Container(color: Colors.red,child: ListView.builder(
             itemCount: 6,
             itemBuilder: (context,index){
             return Card(
               child: ListTile(
                 title: Text('List$index'),
               ),
             );
           }),),
           Container(color: Colors.yellow,),
           Container(color: Colors.blue,),
         ]),
      
      ),
      ),
    );
  }
}
*/
