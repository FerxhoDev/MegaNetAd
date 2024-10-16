import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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

Future<List<Map<String, dynamic>>> _getPagosDelDiaConClientes() async {
  DateTime today = DateTime.now();
  DateTime startOfDay = DateTime(today.year, today.month, today.day);
  DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

  try {
    // Consulta para obtener los pagos de hoy
    QuerySnapshot pagosSnapshot = await FirebaseFirestore.instance
        .collectionGroup('Pagos')
        .where('fecha_pago', isGreaterThanOrEqualTo: startOfDay)
        .where('fecha_pago', isLessThanOrEqualTo: endOfDay)
        .get();

    List<Map<String, dynamic>> pagosConClientes = [];

    for (var pagoDoc in pagosSnapshot.docs) {
      var pagoData = pagoDoc.data() as Map<String, dynamic>;

      // Verificar que tengamos una referencia al cliente
      if (pagoDoc.reference.parent.parent != null) {
        String clientId = pagoDoc.reference.parent.parent!.id;

        // Obtener los datos del cliente
        DocumentSnapshot clienteDoc = await FirebaseFirestore.instance
            .collection('clientes')
            .doc(clientId)
            .get();

        if (clienteDoc.exists) {
          var clienteData = clienteDoc.data() as Map<String, dynamic>;

          // Combinar la información del pago y del cliente
          pagosConClientes.add({
            'nombre': clienteData['nombre'] ?? 'Nombre no disponible',
            'plan_nombre': clienteData['plan_nombre'] ?? 'Plan no disponible',
            'plan_precio': clienteData['plan_precio'] ?? 'Precio no disponible',
            'fecha_pago': pagoData['fecha_pago'],
            'mespago': pagoData['mespago'],
            'total': pagoData['total'],
          });
        }
      } else {
        print('Error: No se encontró la referencia al cliente.');
      }
    }

    return pagosConClientes;
  } catch (e) {
    print('Error al obtener pagos con clientes: $e');
    return [];
  }
}



Stream<QuerySnapshot> _getAllPagosDelDia() {
  return FirebaseFirestore.instance
      .collectionGroup('Pagos') // O la colección correcta de los pagos
      .snapshots();
}


  //Traer pagos del día 
  Stream<QuerySnapshot> _getPagosDelDia() {
  // Obtén la fecha de hoy sin la parte de tiempo
  DateTime hoy = DateTime.now();
  DateTime inicioDelDia = DateTime(hoy.year, hoy.month, hoy.day);
  DateTime finDelDia = inicioDelDia.add(Duration(days: 1));

  return FirebaseFirestore.instance
      .collection('Pagos') // O la colección de pagos
      .where('fecha_pago', isGreaterThanOrEqualTo: inicioDelDia)
      .where('fecha_pago', isLessThan: finDelDia)
      .snapshots();
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
                      context.go('/');
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
                        SizedBox(width: 16.w),
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
                          const Plans(),
                          Container(
                            width: 200.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                            color: Color.fromARGB(255, 57, 57, 57),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navegar a la pantalla de nuevo pago
                              context.goNamed('ListPago');
                            },
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),           
                  ),  
                  SizedBox(height: 70.h, child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: const Row(
                      children: [
                        Text('Pagos del día', style: TextStyle(color: Colors.white),),
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
      color: const Color.fromARGB(255, 37, 37, 37),
    ),
    child: FutureBuilder<List<Map<String, dynamic>>>(
      future: _getPagosDelDiaConClientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los pagos'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay pagos registrados hoy'));
        }

        // Lista de pagos
        List<Map<String, dynamic>> pagos = snapshot.data!;

        return ListView.builder(
          itemCount: pagos.length,
          itemBuilder: (context, index) {
            var pago = pagos[index];

            return ListTile(
              title: Text(pago['nombre'], style: TextStyle(color: Colors.white70)),
              subtitle: Text(pago['plan_nombre'], style: TextStyle(color: Colors.white54)),
              leading: const Icon(Icons.person, color: Colors.white70),
              trailing: Text(
                '+ ${pago['total']}',
                style: TextStyle(color: Colors.green, fontSize: 30.sp),
              ),
              tileColor: const Color.fromARGB(255, 37, 37, 37),
            );
          },
        );
      },
    ),
  ),
),                
                ],
              )
            ),
            
          ],
        )
      ),
    );
  }
}

class Plans extends StatelessWidget {
  const Plans({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de planes
        context.go('/home/planes');
      },
      child: Container(
        width: 200.w,
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color.fromARGB(255, 57, 57, 57),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.content_paste, color: Colors.white60, size: 45.sp,),
            Text('Planes', style: TextStyle(fontSize: 28.sp, color: Colors.white60, fontWeight: FontWeight.bold),)
          ],
        ),
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
    return GestureDetector(
      onTap: () => context.go('/home/Clients'),
      child: Container(
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
                  'Total del mes',
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
