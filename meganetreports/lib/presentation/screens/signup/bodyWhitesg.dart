import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/go_router.dart';

class BodyWhitesg extends StatefulWidget {
  const BodyWhitesg({
    super.key,
  });

  @override
  State<BodyWhitesg> createState() => _BodyWhiteState();
}

class _BodyWhiteState extends State<BodyWhitesg> {

  String email="", password="", name="";

  // Text controllers
  final _usercontroller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
  if (_usercontroller.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
    try {
      // Crear usuario con Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener el ID del usuario registrado
      String uid = userCredential.user!.uid;

      // Guardar información adicional en Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario registrado correctamente.'),
        ),
      );

      // Navegar a la pantalla de inicio
      context.go('/home');

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La contraseña es muy débil.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El correo ya está en uso.'),
          ),
        );
      }
    } catch (e) {
      print(e);
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
      height: 945.h,
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!))),
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Por favor ingrese un nombre';
                          }
                          return null;
                        },
                        controller: _usercontroller,
                        decoration: const InputDecoration(
                            hintText: 'Nombre',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!))),
                      child: TextFormField(
                         validator: (value){
                          if(value!.isEmpty){
                            return 'Por favor ingrese un correo';
                          }
                          return null;
                        },
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
                      child: TextFormField(
                         validator: (value){
                          if(value!.isEmpty){
                            return 'Por favor ingrese un nombre';
                          }
                          return null;
                        },
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
            ),
            
            SizedBox(
              height: 80.h,
            ),            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  color: Colors.blue[800],
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = _emailController.text;
                          password = _passwordController.text;
                          name = _usercontroller.text;
                        });
                      }
                      registration();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 10.w),
                      child: Center(
                        child: Text(
                          'Registrarme',
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
              height: 80.h,
            ),
            Row(
              children: [
                const Text('Ya tienes una cuenta?', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                SizedBox(width: 20.w,),
                GestureDetector(
                  onTap: () {
                    // Navegar a la pantalla de registro
                    context.go('/');
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Inicia sesión',
                        style: TextStyle(
                          color: Colors.blueAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
