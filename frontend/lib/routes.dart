import 'package:flutter/material.dart';
import 'package:frontend/Screens/Bacheca/bacheca.dart';
import 'package:frontend/Screens/Bacheca/commenti_page.dart';
import 'package:frontend/Screens/Bacheca/commento_tile.dart';
import 'package:frontend/Screens/Login/login.dart';
import 'package:frontend/Screens/Register/register.dart';
import 'package:frontend/Screens/Percorsi/dettagli_percorso.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/Register/success.dart';
import 'package:frontend/Screens/borders.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/Screens/Profilo/profilo.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

var router =
    GoRouter(initialLocation: '/home', redirect: _redirect, routes: <GoRoute>[
  GoRoute(
      name: 'Login', path: '/login', builder: (context, state) => LoginPage()),
  GoRoute(
      name: 'Register',
      path: '/register',
      builder: (context, state) => RegisterPage()),
  GoRoute(
      name: 'RegisterSuccess',
      path: '/success',
      builder: (context, state) => RegisterSuccessPage()),
  GoRoute(
    name: 'Home',
    path: '/home',
    builder: (context, state) => PageBorders(),
  ),
  GoRoute(
    name: 'Post comments',
    path: '/comments',
    builder: (context, state) =>
        Commenti(commenti: state.extra as List<CommentoTile>),
  ),
  GoRoute(
    name: 'Dettagli percorso',
    path: '/percorso',
    builder: (context, state) =>
        DettagliPercorso(percorso: state.extra as Percorso),
  ),
  GoRoute(
      name: 'Profilo',
      path: '/profilo',
      builder: (context, state) => ProfiloPage())
]);

String? _redirect(BuildContext context, GoRouterState state) {
  final isLoggedIn = AppService.instance.isLoggedIn;
  final isLoginRoute = state.matchedLocation == LoginPage.route;

  if (state.matchedLocation == '/register' || state.matchedLocation == '/success') return null;

  if (!isLoggedIn && !isLoginRoute) {
    return LoginPage.route;
  }

  return null;
}
