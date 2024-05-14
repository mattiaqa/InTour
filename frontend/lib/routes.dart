import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Feed/feed.dart';
import 'package:frontend/Screens/Feed/Post/Components/Comments/comments.dart';
import 'package:frontend/Screens/Feed/Post/Components/Comments/tile.dart';
import 'package:frontend/Screens/Authentication/Login/login.dart';
import 'package:frontend/Screens/Authentication/Register/register.dart';
import 'package:frontend/Screens/Percorsi/dettagli_percorso.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/Authentication/Register/success.dart';
import 'package:frontend/Screens/Common/borders.dart';
import 'package:frontend/Screens/Share/selected.dart';
import 'package:frontend/Screens/Share/share.dart';
import 'package:frontend/Screens/Share/success.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/Screens/Profile/profilo.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

var router =
    GoRouter(initialLocation: '/home', redirect: _redirect, routes: <GoRoute>[
  GoRoute(
      name: 'Login', 
      path: '/login',
       builder: (context, state) => LoginPage()),
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
    builder: (context, state) => ProfiloPage()),
  GoRoute(
    name: 'Share',
    path: '/share',
    builder: (context, state) => SharePage()),
  GoRoute(
    name: 'SharePreview',
    path: '/sharepreview',
    builder: (context, state) => SharePreviewPage(image: state.extra as File)),
  GoRoute(
    name: 'ShareSuccess',
    path: '/sharesuccess',
    builder: (context, state) => ShareSuccessPage())
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
