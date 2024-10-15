import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawprints/ui/auth/login.dart';
import 'package:pawprints/ui/auth/register.dart';
import 'package:pawprints/screen/dashboard/dashboard.dart';
import 'package:pawprints/ui/main/main.dart';
import 'package:pawprints/ui/main/product/product.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',

        redirect: (BuildContext context, GoRouterState state) => '/main',
      ),
      GoRoute(
        path: '/main',
        builder: (BuildContext context, GoRouterState state) {
          return const MainScreen();
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: '/product',
        builder: (BuildContext context, GoRouterState state) {
          return const ProductScreen();
        },
      ),
    ],
  );
}
