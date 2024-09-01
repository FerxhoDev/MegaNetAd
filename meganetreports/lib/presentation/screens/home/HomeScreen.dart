import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meganetreports/presentation/screens/home/components/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(45, 45, 53, 1),
      appBar: buildAppbar(),
      body: const Body(),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.blue[900],
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          FirebaseAuth.instance.signOut();
          context.goNamed('/');
        },
        child: const Icon(
          Icons.logout_outlined,
          size: 25,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.envelope_fill,
              size: 25, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
