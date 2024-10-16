import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/go_router.dart';

class BodyWhite extends StatefulWidget {
  const BodyWhite({
    super.key,
  });

  @override
  State<BodyWhite> createState() => _BodyWhiteState();
}

class _BodyWhiteState extends State<BodyWhite> {
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      context.go('/home');
      //GoRouter.of(context).go('/home');
    } on FirebaseAuthException catch (e) { 
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay usuario para este correo.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña incorrecta.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 720.w,
      height: 835.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60), topRight: Radius.circular(60)),
      ),
      child: Container(
        padding: EdgeInsets.all(40.h),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(13, 71, 161, .3),
                        blurRadius: 20,
                        offset: Offset(0, 10))
                  ]),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!))),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          hintText: 'Correo',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!))),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          hintText: 'Contraseña',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
             GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de recuperar contraseña
                  context.go('/forgotpassword');
                },
               child: const Text(
                'Olvidaste tu contraseña?',
                style: TextStyle(color: Colors.grey),
                           ),
             ),
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  color: Colors.blue[800],
                  child: InkWell(
                    onTap: () {
                      signIn();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 10.w),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /*InkWell(
              
              onTap: () {},
              child: Container(
                height: 100.h,
                margin: EdgeInsets.symmetric(
                  horizontal: 110.w,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue[800]),
                child: Center(
                    child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),*/
            SizedBox(
  height: 150.h,
),
GestureDetector(
  onTap: () {
    // Navegar a la pantalla de registro
    context.go('/signup');
  },
  child: const Row(
    children: [
      Text(
        'Crearme una Cuenta',
        style: TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold),
      ),
      Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.grey,
      )
    ],
  ),
),
          ],
        ),
      ),
    );
  }
}
