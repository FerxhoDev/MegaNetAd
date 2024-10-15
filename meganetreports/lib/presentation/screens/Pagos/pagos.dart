import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PagoScreen extends StatelessWidget {
  final String clientId;
  const PagoScreen({super.key, required this.clientId});

  Future<Map<String, dynamic>?> _getClientData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('clientes')
        .doc(clientId)
        .get();
    return doc.data() as Map<String, dynamic>?;
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
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getClientData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar datos'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No se encontraron datos'));
            }

            final clientData = snapshot.data!;
            final nombre = clientData['nombre'] ?? 'Cliente Desconocido';
            final plan = clientData['plan_nombre'] ?? 'Plan Desconocido';
            final precio = clientData['plan_precio'] ?? '0.00';

            return Column(
              children: [
                const Retun(),
                Container(
                  height: 1152.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 26, 26, 26),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                      topRight: Radius.circular(50.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Infopago(plan: plan, precio: precio),
                      SizedBox(height: 20.h),
                      InfoClient(nombre: nombre),
                      SizedBox(height: 100.h),
                      Container(
                        height: 100.h,
                        width: 660.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(35, 122, 252, 1),
                              Color.fromRGBO(59, 151, 244, 1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pagar',
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20.w),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class InfoClient extends StatelessWidget {
  final String nombre;
  const InfoClient({
    super.key,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: 660.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color.fromARGB(255, 37, 37, 37),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.white12,
              child: Icon(
                Icons.person,
                color: Colors.white60,
                size: 50.r,
              ),
            ),
            SizedBox(width: 25.w),
            Text(
              nombre,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 35.sp,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Icon(
              Icons.delete,
              color: Colors.red[400],
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}

class Infopago extends StatelessWidget {
  final String plan;
  final String precio;
  const Infopago({
    super.key,
    required this.plan,
    required this.precio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.h,
      width: 660.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color.fromARGB(255, 16, 16, 16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text('Plan: $plan',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold)),
                    Text(
                      'Q$precio.00',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 55.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 160.w,
                ),
                Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.white60,
                      size: 50.r,
                    ),
                    Text(
                      'Marzo 2024',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descuento:',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.grey[800],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Q 0.00',
                            hintStyle: TextStyle(
                                color: Colors.white38, fontSize: 32.sp),
                            border: InputBorder.none, // Sin borde visible
                            enabledBorder:
                                InputBorder.none, // Para cuando está habilitado
                            focusedBorder:
                                InputBorder.none, // Para cuando está en foco
                          ),
                          style: const TextStyle(
                              color: Colors
                                  .white60), // Para que el texto sea blanco
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 75.w,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Q$precio',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Retun extends StatelessWidget {
  const Retun({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white60,
          ),
        ),
        SizedBox(width: 200.w),
        Text(
          'Pagos',
          style: TextStyle(
              fontSize: 30.sp,
              color: Colors.white60,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
