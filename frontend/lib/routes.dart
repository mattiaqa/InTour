import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Feed/Post/post.dart';
import 'package:frontend/Screens/Feed/feed.dart';
import 'package:frontend/Screens/Feed/Post/Components/Comments/comments.dart';
import 'package:frontend/Screens/Authentication/Login/login.dart';
import 'package:frontend/Screens/Authentication/Register/register.dart';
import 'package:frontend/Screens/Feed/search.dart';
import 'package:frontend/Screens/Map/presentation/map_page.dart';
import 'package:frontend/Screens/Percorsi/dettagli_percorso.dart';
import 'package:frontend/Screens/Authentication/Register/success.dart';
import 'package:frontend/Screens/Common/borders.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/Profile/Components/friends.dart';
import 'package:frontend/Screens/Share/selected.dart';
import 'package:frontend/Screens/Share/share.dart';
import 'package:frontend/Screens/Share/success.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/Screens/Profile/profilo.dart';
import 'package:go_router/go_router.dart';

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
    name: 'Percorsi',
    path: '/percorsi',
    builder: (context, state) => Percorsi(chooseLocationForPosts: state.extra as bool),
  ),
  GoRoute(
    name: 'Dettagli percorso',
    path: '/percorso',
    builder: (context, state) =>
        DettagliPercorso(percorso: state.extra as Percorso),
  ),
  GoRoute(
      name: 'Dettaglio post',
      path: '/post',
      builder: (context, state) {
        return Scaffold(
            appBar: PageTitle(title: 'Post'), body: state.extra as BachecaTile);
      }),
  GoRoute(
    name: 'Post comments',
    path: '/comments',
    builder: (context, state) => Commenti(
        postId: (state.extra as List<dynamic>)[0],
        commenti: (state.extra as List<dynamic>)[1],
        postUser: (state.extra as List<dynamic>)[2]
      ),
  ),
  GoRoute(
      name: 'Profilo',
      path: '/profilo',
      builder: (context, state) => ProfiloPage(
            username: state.extra as String,
          )),
  GoRoute(
      name: 'ProfiloUtente',
      path: '/userprofile',
      builder: (context, state) {
        return PageBorders(
          selectedIndex: 4,
          username: state.extra as String,
        );
      }),
  GoRoute(
    name: 'Share',
    path: '/share',
    builder: (context, state) => SharePage(),
  ),
  GoRoute(
    name: 'Map',
    path: '/map',
    builder: (context, state) => MapPage(),
  ),
  GoRoute(
      name: 'SharePreview',
      path: '/sharepreview',
      builder: (context, state) =>
          SharePreviewPage(image: state.extra as File)),
  GoRoute(
      name: 'ShareSuccess',
      path: '/sharesuccess',
      builder: (context, state) => ShareSuccessPage()),
  GoRoute(name: 'Feed', path: '/feed', builder: (context, state) => Bacheca()),
  GoRoute(
      name: 'SearchUser',
      path: '/searchuser',
      builder: (context, state) => SearchUserPage()),
  GoRoute(
      name: 'Friends',
      path: '/friends',
      builder: (context, state) => FriendsPage(username: state.extra as String))
]);

String? _redirect(BuildContext context, GoRouterState state) {
  final isLoggedIn = AppService.instance.isLoggedIn;
  final isLoginRoute = state.matchedLocation == LoginPage.route;

  if (state.matchedLocation == '/register' ||
      state.matchedLocation == '/success') return null;

  if (!isLoggedIn && !isLoginRoute) {
    return LoginPage.route;
  }

  return null;
}
