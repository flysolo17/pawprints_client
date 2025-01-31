import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawprints/Aboutsystem/AboutSystemCard.dart';

import 'package:pawprints/credits/CreditScreen.dart';
import 'package:pawprints/developer/DeveloperScreen.dart';

import 'package:pawprints/screen/pets/create_pet.dart';
import 'package:pawprints/screen/product/view_product.dart';
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
          }),
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
      GoRoute(
        path: '/product/:id',
        builder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['id'] ?? "";
          return ViewProduct(id: id);
        },
      ),
      GoRoute(
        path: '/pet/create',
        builder: (BuildContext context, GoRouterState state) {
          return const CreatePet();
        },
      ),
      //about,credits,developers
      GoRoute(
        path: '/about',
        builder: (BuildContext context, GoRouterState state) {
          return const AboutScreen();
        },
      ),
      GoRoute(
        path: '/credits',
        builder: (BuildContext context, GoRouterState state) {
          return CreditsScreen();
        },
      ),
      GoRoute(
        path: '/developers',
        builder: (BuildContext context, GoRouterState state) {
          return DeveloperScreen();
        },
      ),
    ],
  );
}
