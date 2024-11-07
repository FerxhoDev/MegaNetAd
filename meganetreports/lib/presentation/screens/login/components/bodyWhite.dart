import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meganetreports/Provider/appProvider.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';


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

  String? _selectedRole;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('usersperm')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (result.docs.isNotEmpty) {
          if (!mounted) return;
          // Actualizar el estado de autenticación en el Provider
          Provider.of<AuthProviders>(context, listen: false).setUser(user);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Este correo no está autorizado para iniciar sesión.'),
              backgroundColor: Colors.red,
            ),
          );
          await _auth.signOut();
          await _googleSignIn.signOut();
        }
      }
    } catch (e) {
      print('Error durante el inicio de sesión: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Ocurrió un error durante el inicio de sesión. $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  /*Future signIn() async {
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
  }*/

  Future<void> signIn(BuildContext context) async {
  try {
    // Intenta iniciar sesión con Firebase Auth
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Si el inicio de sesión es exitoso, verifica si el usuario está autorizado
    if (userCredential.user != null) {
      bool isAuthorized = await checkUserAuthorization(userCredential.user!.email);
      
      if (isAuthorized) {
        // El usuario está autorizado, actualiza el Provider y navega al dashboard
        if (context.mounted) {
          Provider.of<AuthProviders>(context, listen: false).setUser(userCredential.user);
          context.go('/home');
        }
      } else {
        // El usuario no está autorizado
        if (context.mounted) {
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Este correo no está autorizado para iniciar sesión.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de autenticación: ${e.message}'),
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
        ),
      );
    }
  }
}

Future<bool> checkUserAuthorization(String? email) async {
  if (email == null) return false;

  try {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('usersperm')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  } catch (e) {
    print('Error al verificar la autorización del usuario: $e');
    return false;
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
                      signIn(context);
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
            SizedBox(
              height: 20.h,
            ),
            SignInButton(
                      Buttons.google,
                      text: 'Iniciar con Google',
                      onPressed: () => _handleSignIn(context),
                    ),

          ],
        ),
      ),
    );
  }
}
