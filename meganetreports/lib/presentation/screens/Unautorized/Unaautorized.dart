import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meganetreports/Provider/appProvider.dart';
import 'package:provider/provider.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Este correo no está autorizado para iniciar sesión.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthProviders>().signOut();
                context.go('/');
              },
              child: const Text('Volver al login'),
            ),
          ],
        ),
      ),
    );
  }
}