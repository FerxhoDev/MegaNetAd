import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meganetreports/models/incidentsmodel.dart';
import 'package:meganetreports/presentation/screens/articles/inventary.dart';
//import 'package:meganetreports/main_page.dart';
import 'package:meganetreports/presentation/screens/home/HomeScreen.dart';
import 'package:meganetreports/presentation/screens/info__incidents/incidents_screen.dart';
import 'package:meganetreports/presentation/screens/login/components/login.dart';
import 'package:meganetreports/presentation/screens/signup/signup.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Login();
      },
    ),
    GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'info_incidents',
              name: 'info_incidents',
              builder: (BuildContext context, GoRouterState state) {
                incidentModel snapshot = state.extra as incidentModel;
                return InsidentsScreen(snapshot: snapshot);
              },
            ),
            GoRoute(
              path: 'inventary',
              name: 'inventary',
              builder: (BuildContext context, GoRouterState state) {
                return const InventaryScreen();
              },
            ),
             GoRoute(
              path: 'signup',
              name: 'signup',
              builder: (BuildContext context, GoRouterState state) {
                return const SignUp();
              },
            ),
          ],
        ),
       
  ],
  
);
