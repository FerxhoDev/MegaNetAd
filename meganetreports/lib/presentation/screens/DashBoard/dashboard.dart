import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? user;
  String? userName;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _getUserName();
  }

  Future<void> _getUserName() async {
    if (user != null) {
      // Accede a Firestore para obtener el documento del usuario
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name']; // Asigna el nombre del usuario
        });
      } else {
        setState(() {
          userName = "Unknown User"; // Valor por defecto si el documento no existe
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,37, 37, 37,),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left:40.w, right: 20.w, top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido',
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '$userName',
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 33.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  IconButton(
                    onPressed: () {
                      // Cerrar sesión
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              height: 1111.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 26, 26),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(                    
                      children: [
                        SizedBox(width: 5.w),
                        const TotalDia(),
                        SizedBox(width: 20.w),
                        const TotalMes()
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: VerClients()                    
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 37, 37, 37),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const EditarPago(),
                          Container(
                            width: 200.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                            color: Color.fromARGB(255, 57, 57, 57),
                            ),
                          ),
                          Container(
                            width: 200.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(35, 122, 252, 1),
                                  Color.fromRGBO(59, 151, 244, 1),
                                ],
                              ),
                            ),
                            child: 
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.my_library_add_rounded, color: Colors.white60, size: 45.sp,),
                                  Text('Nuevo Pago', style: TextStyle(fontSize: 28.sp, color: Colors.white60, fontWeight: FontWeight.bold),)
                                ],
                              ),
                          ),
                        ],
                      ),
                    ),           
                  ),  
                  SizedBox(height: 70.h, child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: const Row(
                      children: [
                        Text('Últimos Pagos', style: TextStyle(color: Colors.white),),
                        Spacer(),
                        Text('Ver todos...', style: TextStyle(color: Colors.white60),),
                      ],
                    ),
                  ),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 400.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color:  const Color.fromARGB(255, 37, 37, 37),
                      ),
                      child: ListView(
                        children:[
                          ListTile(
                            tileColor: Color.fromARGB(255, 231, 94, 94),
                            title: const Text('Paula López', style: TextStyle(color: Colors.white70),),
                            subtitle: const Text('Básico', style: TextStyle(color: Colors.white54),),
                            leading: const Icon(Icons.person),
                            trailing: Text('+ Q200', style: TextStyle(color: Colors.green, fontSize: 30.sp),),
                            style: ListTileStyle.drawer,
                          ),
                          //const Divider(),
                          ListTile(
                            title: const Text('Conni Paz', style: TextStyle(color: Colors.white70),),
                            subtitle: const Text('Básico', style: TextStyle(color: Colors.white54),),
                            leading: const Icon(Icons.person),
                            trailing: Text('+ Q200', style: TextStyle(color: Colors.green, fontSize: 30.sp),),
                          ),
                          //const Divider(),
                          ListTile(
                            title: const Text('Rosa Díaz', style: TextStyle(color: Colors.white70),),
                            subtitle: const Text('Básico', style: TextStyle(color: Colors.white54),),
                            leading: const Icon(Icons.person),
                            trailing: Text('+ Q200', style: TextStyle(color: Colors.green, fontSize: 30.sp),),
                          ),
                          //const Divider(),
                          ListTile(
                            title: const Text('Erick Méndez', style: TextStyle(color: Colors.white70),),
                            subtitle: const Text('Plus', style: TextStyle(color: Colors.white54),),
                            leading: const Icon(Icons.person),
                            trailing: Text('+ Q300', style: TextStyle(color: Colors.green, fontSize: 30.sp),),
                          ),
                          //const Divider(),
                          ListTile(
                            title: const Text('Jaime López', style: TextStyle(color: Colors.white70),),
                            subtitle: const Text('Básico', style: TextStyle(color: Colors.white54),),
                            leading: const Icon(Icons.person),
                            trailing: Text('+ Q200', style: TextStyle(color: Colors.green, fontSize: 30.sp),),
                          ),
                          //const Divider(),
                        ],
                      ),
                    ),
                  )                
                ],
              )
            ),
            
          ],
        )
      ),
    );
  }
}

class EditarPago extends StatelessWidget {
  const EditarPago({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Color.fromARGB(255, 57, 57, 57),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.content_paste, color: Colors.white60, size: 45.sp,),
          Text('Planes', style: TextStyle(fontSize: 28.sp, color: Colors.white60, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}

class VerClients extends StatelessWidget {
  const VerClients({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 37, 37),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 20.w),
          Icon(
            Icons.groups_2,
            color: Colors.white60,
            size: 60.sp,
          ),
          SizedBox(width: 20.w),
          const Text('Cllientes', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white60,
            size: 30.sp,
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}

class TotalMes extends StatelessWidget {
  const TotalMes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.w,
      height: 225.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 37, 37),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                 const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                 const SizedBox(width: 10),
                 Text(
                  'Total del día',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.insights,
                color: Colors.white,
                size: 60.sp,
              ),
              SizedBox(width: 15.w),
              Text(
                'Q10,200',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TotalDia extends StatelessWidget {
  const TotalDia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.w,
      height: 225.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(35, 122, 252, 1),
            Color.fromRGBO(59, 151, 244, 1),
          ],
        ),
       // color: const Color.fromRGBO(13, 71, 161, 1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                 const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                 const SizedBox(width: 10),
                 Text(
                  'Total del día',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.keyboard_double_arrow_up_rounded,
                color: Colors.white,
                size: 60.sp,
              ),
              SizedBox(width: 15.w),
              Text(
                'Q1,200',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 55.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
