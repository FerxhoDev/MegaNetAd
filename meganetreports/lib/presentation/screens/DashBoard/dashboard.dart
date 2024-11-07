import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meganetreports/Provider/appProvider.dart';
import 'package:provider/provider.dart';

Stream<QuerySnapshot<Map<String, dynamic>>> _getPagosDelDia() {
  DateTime startOfDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  return FirebaseFirestore.instance
      .collectionGroup(
          'Pagos') // Obtenemos la subcolección 'Pagos' de todos los clientes
      .where('fecha_pago',
          isGreaterThanOrEqualTo:
              startOfDay) // Filtramos por pagos del día actual
      .snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> _getPagosDelMesStream() {
  DateTime now = DateTime.now();
  DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
  DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

  return FirebaseFirestore.instance
      .collectionGroup('Pagos')
      .where('fecha_pago', isGreaterThanOrEqualTo: firstDayOfMonth)
      .where('fecha_pago', isLessThan: firstDayOfNextMonth)
      .snapshots();
}




class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? user;
  String? userName;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userRole;

Future<void> _logout(BuildContext context) async {
  try {
    final authProvider = Provider.of<AuthProviders>(context, listen: false);
    await authProvider.signOut();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada correctamente.')),
      );
      context.go('/');
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
      );
    }
  }
}

Future<void> fetchUserDetails() async {
  final userDetails = await fetchUserNameAndRole();
    if (userDetails != null && mounted) {
      setState(() {
        String name = userDetails['name']!;
        // Si el nombre tiene más de 15 caracteres, lo recortamos y añadimos '...'
        userName = name.length > 15 ? '${name.substring(0, 15)}...' : name;
        userRole = userDetails['role'];
      });
    }
  }

  

  Future<Map<String, String>?> fetchUserNameAndRole() async {
    try {
      // Obtiene el correo del usuario actual logueado
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      
      if (userEmail == null) {
        print('No hay un usuario logueado.');
        return null; // Retorna null si no hay un usuario logueado
      }

      // Realiza la consulta en la colección `usersperm` para obtener los campos `name` y `rol`
      final snapshot = await FirebaseFirestore.instance
          .collection('usersperm')
          .where('email', isEqualTo: userEmail)
          .limit(1) // Limita la consulta a 1 documento ya que el email es único
          .get();

      if (snapshot.docs.isEmpty) {
        print('Usuario no encontrado en la colección usersperm.');
        return null; // Retorna null si no se encuentra el documento
      }

      // Accede a los datos del primer documento encontrado
      final userDoc = snapshot.docs.first;
      final String name = userDoc['name'] as String;
      final String role = userDoc['rol'] as String;

      // Retorna el nombre y el rol como un mapa
      return {
        'name': name,
        'role': role,
      };
    } catch (e) {
      print('Error al obtener el nombre y rol del usuario: $e');
      return null; // Retorna null en caso de error
    }
  }



  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchUserDetails();
  }

  

  Stream<QuerySnapshot<Map<String, dynamic>>> _getPagosConClientesStream() {
    return FirebaseFirestore.instance.collection('clientes').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        37,
        37,
        37,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40.w, right: 20.w, top: 10.h),
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
                    _logout(context);
                    // ir a login Login()
                    context.goNamed('root');
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: VerClients()),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.my_library_add_rounded,
                                    color: Colors.white60,
                                    size: 45.sp,
                                  ),
                                  Text(
                                    'Nuevo Pago',
                                    style: TextStyle(
                                        fontSize: 28.sp,
                                        color: Colors.white60,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: const Row(
                        children: [
                          Text(
                            'Pagos del día',
                            style: TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            'Ver todos...',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: double.infinity,
                        height: 400.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: const Color.fromARGB(255, 37, 37, 37),
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _getPagosConClientesStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(color: Colors.blue[700],));
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error al cargar los pagos'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                  child: Text('No se encontraron pagos'));
                            }

                            final clientDocs = snapshot.data!.docs;

                            List<Widget> pagosList = [];

                            for (var clientDoc in clientDocs) {
                              final clientData =
                                  clientDoc.data() as Map<String, dynamic>;
                              final clientName =
                                  clientData['nombre'] ?? 'Cliente Desconocido';

                              final pagosRef =
                                  clientDoc.reference.collection('Pagos').where(
                                        'fecha_pago',
                                        isGreaterThanOrEqualTo: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                      );

                              pagosList.add(
                                StreamBuilder<QuerySnapshot>(
                                  stream: pagosRef.snapshots(),
                                  builder: (context, pagosSnapshot) {
                                    if (!pagosSnapshot.hasData ||
                                        pagosSnapshot.data!.docs.isEmpty) {
                                      return Container(); // No mostrar si no hay pagos
                                    }

                                    final pagosDocs = pagosSnapshot.data!.docs;

                                    return Column(
                                      children: pagosDocs.map((pagoDoc) {
                                        final pagoData = pagoDoc.data()
                                            as Map<String, dynamic>;
                                        final mesPago = pagoData['mespago'] ??
                                            'Mes no registrado';
                                        final total =
                                            pagoData['total'] ?? '0.00';

                                        return ListTile(
                                          title: Text(clientName,
                                              style: const TextStyle(
                                                  color: Colors.white70)),
                                          subtitle: Text(mesPago,
                                              style: const TextStyle(
                                                  color: Colors.white54)),
                                          leading: const Icon(Icons.person),
                                          trailing: Text('+ Q$total',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 30.sp)),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              );
                            }

                            return ListView(children: pagosList);
                          },
                        )),
                  ),
                ],
              )),
        ],
      )),
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
            Icon(
              Icons.content_paste,
              color: Colors.white60,
              size: 45.sp,
            ),
            Text(
              'Planes',
              style: TextStyle(
                  fontSize: 28.sp,
                  color: Colors.white60,
                  fontWeight: FontWeight.bold),
            )
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
            const Text(
              'Cllientes',
              style:
                  TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
            ),
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
  const TotalMes({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _getPagosDelMesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.blue[700]));
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los pagos del mes'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay pagos este mes'));
        }

        // Calcular el total del mes
        double totalMes = 0;
        for (var doc in snapshot.data!.docs) {
          double total = double.tryParse(doc['total']) ?? 0;
          totalMes += total;
        }

        return Container(
          width: 325.w,
          height: 225.h,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 37, 37, 37),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
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
                    'Q${totalMes.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}


class TotalDia extends StatelessWidget {
  const TotalDia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _getPagosDelDia(), // Usamos el nuevo stream de pagos del día
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.blue[700]));
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los pagos'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildTotalContainer(0.00); // Si no hay datos, el total es 0
        }

        // Calculamos el total sumando los campos 'total' de cada pago
        double totalDia = 0;
        for (var doc in snapshot.data!.docs) {
          // Convertimos el campo 'total' a double (puede estar almacenado como string en Firestore)
          totalDia += double.tryParse(doc['total']) ?? 00;
        }

        return _buildTotalContainer(totalDia); // Mostramos el total calculado
      },
    );
  }

  // Método para construir el widget con el total
  Widget _buildTotalContainer(double totalDia) {
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
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
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
                'Q${totalDia.toStringAsFixed(2)}', // Mostramos el total calculado
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45.sp,
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
