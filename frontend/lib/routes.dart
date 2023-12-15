import 'package:frontend/Screens/Bacheca/bacheca.dart';
import 'package:frontend/Screens/Login/login.dart';
import 'package:frontend/Screens/Profilo/profilo.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/borders.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(initialLocation: '/login', routes: <GoRoute>[
  GoRoute(
      name: 'Login', path: '/login', builder: (context, state) => LoginPage()),
  GoRoute(
    name: 'Home',
    path: '/home',
    builder: (context, state) => PageBorders(),
  ),
  GoRoute(
      name: 'Profilo',
      path: '/profilo',
      builder: (context, state) => ProfiloPage()),
]);
