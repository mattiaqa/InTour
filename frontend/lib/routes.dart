import 'package:frontend/Screens/Bacheca/bacheca.dart';
import 'package:frontend/Screens/Percorsi/percorsi.dart';
import 'package:frontend/Screens/borders.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter
(
  initialLocation: '/bacheca',
  routes: <GoRoute>
  [
    GoRoute
    (
      name: 'Percorsi',
      path: '/percorsi',
      builder: (context, state) => Percorsi()//Percorsi(key: state.pageKey,),
    ),
    GoRoute
    (
      name: 'Bacheca',
      path: '/bacheca',
      builder: (context, state) => Bacheca(),
    ),
  ]
);