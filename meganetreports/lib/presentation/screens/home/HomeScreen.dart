import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
        bottomNavigationBar: const Bottonbar());
  }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.blue[900],
      elevation: 0,
      leading: const Icon(
        Icons.apps_rounded,
        size: 25,
        color: Colors.white,
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

class Bottonbar extends StatelessWidget {
  const Bottonbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      items: const [
        Icon(
          Icons.home,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.inventory_sharp,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 1) {
          context.goNamed('inventory');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/create');
        }
      },
      color: const Color.fromRGBO(13, 71, 161, 1),
      backgroundColor: const Color.fromRGBO(45, 45, 53, 1),
    );
  }
}
