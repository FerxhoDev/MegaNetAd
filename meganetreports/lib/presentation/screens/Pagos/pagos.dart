import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


final TextEditingController _descuentoController = TextEditingController();
final TextEditingController _descDescuentoController = TextEditingController();


Future<void> savePayment({
  required String clientId, // ID del cliente
  required DateTime fechaPago, // Fecha y hora del pago
  required String mesPago, // Mes del pago (ejemplo: "Septiembre 2024")
  required String precioOriginal,
  required TextEditingController descuentoController,
  required TextEditingController descDescuentoController,
}) async {
  try {
    // Referencia a la subcolección 'Pagos' del cliente
    CollectionReference pagosRef = FirebaseFirestore.instance
        .collection('clientes')
        .doc(clientId)
        .collection('Pagos');

    double precioOriginalDouble = double.parse(precioOriginal);
    double descuento = double.tryParse(descuentoController.text) ?? 0;
    double total = precioOriginalDouble - descuento;
    // Estructura de los datos del pago
    Map<String, dynamic> pagoData = {
      'fecha_pago': fechaPago,
      'mespago': mesPago,
      'total': total.toString(),
      'precio_original': precioOriginal,
    };

    // Si hay un descuento, lo añadimos
    if (descuento > 0) {
      pagoData['descuento'] = descuentoController.text;
      pagoData['descdescuento'] = descDescuentoController.text;
    }

    // Guardar el pago en Firestore
    await pagosRef.add(pagoData);
    print('Pago guardado correctamente');
  } catch (e) {
    print('Error al guardar el pago: $e');
  }
}

String getNextMonth(String lastPaymentMonth) {
  // Separar el mes y el año del string de entrada
  final parts = lastPaymentMonth.split(' ');
  final monthString = parts[0];
  final year = int.parse(parts[1]);

  // Crear un mapa de los meses
  const monthMap = {
    'Enero': 1,
    'Febrero': 2,
    'Marzo': 3,
    'Abril': 4,
    'Mayo': 5,
    'Junio': 6,
    'Julio': 7,
    'Agosto': 8,
    'Septiembre': 9,
    'Octubre': 10,
    'Noviembre': 11,
    'Diciembre': 12,
  };

  // Obtener el número del mes actual
  int currentMonth = monthMap[monthString] ?? 1;

  // Calcular el siguiente mes y el año correspondiente
  if (currentMonth == 12) {
    // Si es diciembre, el siguiente mes es enero del siguiente año
    return 'Enero ${year + 1}';
  } else {
    // En cualquier otro caso, solo aumentamos el mes
    int nextMonth = currentMonth + 1;
    String nextMonthString = monthMap.keys.elementAt(nextMonth - 1);
    return '$nextMonthString $year';
  }
}

class PagoScreen extends StatelessWidget {
  final String clientId;
  const PagoScreen({super.key, required this.clientId});

  Future<Map<String, dynamic>?> _getClientData() async {
    try {
      // Obtener los datos del cliente
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('clientes')
          .doc(clientId)
          .get();

      // Obtener el último pago del cliente
      QuerySnapshot pagosSnapshot = await FirebaseFirestore.instance
          .collection('clientes')
          .doc(clientId)
          .collection('Pagos')
          .orderBy('fecha_pago', descending: true)
          .limit(1)
          .get();

      Map<String, dynamic>? clientData = doc.data() as Map<String, dynamic>?;

      if (clientData != null && pagosSnapshot.docs.isNotEmpty) {
        // Agregar el último pago a los datos del cliente
        clientData['ultimo_pago'] = pagosSnapshot.docs.first.data();
      }

      return clientData;
    } catch (e) {
      print('Error al obtener datos del cliente: $e');
      return null;
    }
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
            final ultimoPago = clientData['ultimo_pago'] ?? {};
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
                      Infopago(plan: plan, precio: precio, mes: ultimoPago),
                      SizedBox(height: 20.h),
                      InfoClient(nombre: nombre),
                      SizedBox(height: 100.h),
                      GestureDetector(
                        onTap: () {
                          if(_descuentoController.text.isNotEmpty && _descDescuentoController.text.isEmpty){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  icon: const Icon(Icons.error_outline_rounded,
                                      color: Color.fromRGBO(35, 122, 252, 1)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 37, 37, 37),
                                  title: const Text('Error', style: TextStyle(color: Colors.white70),),
                                  content: const Text(
                                      'Por favor, ingrese el concepto del descuento', style: TextStyle(color: Colors.white70),),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Aceptar', style: TextStyle(color: Colors.blue),),
                                    ),
                                  ],
                                );
                              });
                            return;
                          }else if(_descuentoController.text.isEmpty && _descDescuentoController.text.isNotEmpty){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  icon: const Icon(Icons.error_outline_rounded,
                                      color: Color.fromRGBO(35, 122, 252, 1)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 37, 37, 37),
                                  title: const Text('Error', style: TextStyle(color: Colors.white70),),
                                  content: const Text(
                                      'Por favor, ingrese el Descuento', style: TextStyle(color: Colors.white70),),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Aceptar', style: TextStyle(color: Colors.blue),),
                                    ),
                                  ],
                                );
                              });
                            return;
                          }
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  icon: const Icon(Icons.save_as_rounded,
                                      color: Color.fromRGBO(35, 122, 252, 1)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 37, 37, 37),
                                  title: const Text('Confirmar Pago', style: TextStyle(color: Colors.white70),),
                                  content: const Text(
                                      '¿Estás seguro de que deseas realizar el pago?', style: TextStyle(color: Colors.white70),),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar', style: TextStyle(color: Colors.blue),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        String mesPagoAnterior =
                                            ultimoPago['mespago'] ?? '';
                                        String siguienteMes =
                                            getNextMonth(mesPagoAnterior);
                                        savePayment(
                                          clientId: clientId,
                                          fechaPago: DateTime.now(),
                                          mesPago: siguienteMes,
                                          descDescuentoController: _descDescuentoController,
                                          descuentoController: _descuentoController,
                                          precioOriginal: precio,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Aceptar', style: TextStyle(color: Colors.blue)),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
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

class Infopago extends StatefulWidget {
  final String plan;
  final String precio;
  final Map<String, dynamic> mes;

  const Infopago({
    super.key,
    required this.plan,
    required this.precio,
    required this.mes,
  });

  @override
  State<Infopago> createState() => _InfopagoState();
}

class _InfopagoState extends State<Infopago> {
  late double _total;
  bool _descuentoAplicado = false;

  @override
  void initState() {
    super.initState();
    _total = double.parse(widget.precio);
    _descuentoController.addListener(_updateTotal);
  }
  @override
void dispose() {
  // Elimina el listener antes de descartar el widget
  _descuentoController.removeListener(_updateTotal);
  super.dispose();
}


  void _updateTotal() {
    setState(() {
      double descuento = double.tryParse(_descuentoController.text) ?? 0;
      _total = double.parse(widget.precio) - descuento;
      _descuentoAplicado = descuento > 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    final mesPagoAnterior = widget.mes['mespago'] ?? 'N/A';
    String siguienteMes = getNextMonth(mesPagoAnterior);
    return Container(
      height: 570.h,
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
                    Text('Plan: ${widget.plan}',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold)),
                    Text(
                      'Q${widget.precio}.00',
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
                      siguienteMes,
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 25.sp,
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
                          controller: _descuentoController,
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
                      'Q${_total.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Descripción:',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Container(
                        width:680.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.grey[800],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: TextFormField(
                            controller: _descDescuentoController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Por concepto de...',
                              hintStyle: TextStyle(
                                  color: Colors.white38,),
                              border: InputBorder.none, // Sin borde visible
                              enabledBorder:
                                  InputBorder.none, // Para cuando está habilitado
                              focusedBorder:
                                  InputBorder.none, // Para cuando está en foco
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingrese una descripción del descuento';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                color: Colors
                                    .white60), // Para que el texto sea blanco
                          ),
                        ),
                      ),
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
