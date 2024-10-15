import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meganetreports/presentation/screens/Clients/addClient.dart';
import 'package:meganetreports/presentation/screens/Clients/clients.dart';
import 'package:meganetreports/presentation/screens/DashBoard/dashboard.dart';
import 'package:meganetreports/presentation/screens/Pagos/listPagoClients.dart';
import 'package:meganetreports/presentation/screens/Pagos/pagos.dart';
import 'package:meganetreports/presentation/screens/Planes/planes.dart';
import 'package:meganetreports/presentation/screens/fotgotpassword/forgotpassword.dart';
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
      routes: [
        GoRoute(
              path: 'forgotpassword',
              name: 'forgotpassword',
              builder: (BuildContext context, GoRouterState state) {
                return const ForgotMyPassword();
              },
            ),
        GoRoute(
              path: 'signup',
              name: 'signup',
              builder: (BuildContext context, GoRouterState state) {
                return const SignUp();
              },
            ),
      ]
    ),
    GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const Dashboard();
          },
          routes: [
            GoRoute(
              path: 'ListPago',
              name: 'ListPago',
              builder: (BuildContext context, GoRouterState state) {
                return const Listpagoclients(); 
              },
              routes: [
                GoRoute(
                  path: 'NPago',
                  name: 'NPago',
                  builder: (BuildContext context, GoRouterState state) {
                    final clientId = state.extra;
                    return PagoScreen(clientId: clientId,); 
                  },
                ),
              ]
            ),
            GoRoute(
              path: 'clients',
              name: 'clients',
              builder: (BuildContext context, GoRouterState state) {
                return const Clients();
              },
              routes: [
                GoRoute(
                  path: 'AddClients',
                  name: 'AddClients',
                  builder: (BuildContext context, GoRouterState state) {
                  return const AddClients();               },
                ),
              ]
            ),
            GoRoute(
              path: 'planes',
              name: 'planes',
              builder: (BuildContext context, GoRouterState state) {
                return Planes();
              },
            ),
          ],
        ),      
  ],
  
);
