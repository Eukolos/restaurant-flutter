

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management_system/src/views/home_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: router,
      routes: router._routes,
      redirect: router._redirectLogic,



  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref);

  Future<String?> _redirectLogic(BuildContext context, GoRouterState state) async {
    if (state.matchedLocation == null || state.matchedLocation == '/home') {
      return '/';
    } else {
      return null;
    }
  }



  List<GoRoute> get _routes => [

    GoRoute(
      name: 'home',
      builder: (context, state) => const HomeView(title: 'emin',),
      path: '/',
    ),
  ];
}

