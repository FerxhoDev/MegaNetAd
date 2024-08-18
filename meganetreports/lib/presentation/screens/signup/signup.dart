import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meganetreports/presentation/screens/signup/bodyWhitesg.dart';
import 'package:meganetreports/presentation/screens/signup/headerTextsg.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromRGBO(13, 71, 161, 1),
              Color.fromRGBO(45, 45, 53, 1),
            ]
          )
        ),
        child: SingleChildScrollView(
          scrollDirection:Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h,),
              const HeaderTextsg(),
              SizedBox(height: 10.h,),
              const BodyWhitesg(),
              
            ],
          ),
        ),
      ),
    );
  }
}
