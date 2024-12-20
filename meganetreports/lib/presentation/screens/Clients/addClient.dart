import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Plan {
  final String name;
  final String price;

  Plan({required this.name, required this.price});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Plan && other.name == name && other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}

class AddClients extends StatefulWidget {
  const AddClients({super.key});

  @override
  State<AddClients> createState() => _AddClientsState();
}

class _AddClientsState extends State<AddClients> {
  // Controladores de los campos
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstPaymonth = TextEditingController();
  final TextEditingController firstPay = TextEditingController();

  // Variable para almacenar el plan seleccionado
  Plan? selectedPlan;

  // Método para obtener los planes de Firestore
  Future<List<Plan>> _fetchPlans() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('planes').get();
    return snapshot.docs.map((doc) {
      return Plan(
        name: doc['nombre'] as String,
        price: doc['precio'] as String,
      );
    }).toList();
  }

  // Función para guardar cliente en Firestore
  Future<void> _saveClient() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedPlan == null ||
        firstPay.text.isEmpty) {
      // Muestra un mensaje de error si alguno de los campos está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    // Datos del cliente a guardar
    Map<String, dynamic> clientData = {
      'nombre': nameController.text,
      'telefono': phoneController.text,
      'plan_nombre': selectedPlan!.name,
      'plan_precio': selectedPlan!.price,
    };

    try {
      // Guarda el cliente en la colección 'clientes' de Firestore y obtiene el ID del documento recién creado
      DocumentReference clientRef = await FirebaseFirestore.instance
          .collection('clientes')
          .add(clientData);

      // Ahora guarda la información del primer pago en la subcolección 'Pagos'
      Map<String, dynamic> pagoData = {
        'mespago': firstPaymonth.text, // Guardar el mes de pago desde el controller
        'fecha_pago': Timestamp.now(), // Timestamp con el horario actual
        'precio_original': selectedPlan!.price, // Precio original del plan
        'total': firstPay.text, // Precio del plan
      };

      // Agrega el pago a la subcolección 'Pagos' del cliente recién creado
      await clientRef.collection('Pagos').add(pagoData);

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cliente y primer pago guardados exitosamente.')),
      );

      // Limpia los campos después de guardar
      nameController.clear();
      phoneController.clear();
      firstPay.clear(); // Limpia también el campo del primer pago
      firstPaymonth.clear(); // Limpia también el campo del mes de pago
      setState(() {
        selectedPlan = null;
      });
    } catch (e) {
      // En caso de error, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar cliente o pago: $e')),
      );
      print('Error al guardar cliente o pago: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(45, 45, 53, 1),
      appBar: AppBar(
        title: const Text(
          'Agregar Cliente',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 37, 37, 37),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(13, 71, 161, 1),
                    spreadRadius: .5,
                    blurRadius: 15,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  // Campo para el nombre del cliente
                  const Text(
                    'Nombre',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Ingresa el nombre del cliente',
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(13, 71, 161,
                                1)), // Borde azul cuando tiene foco
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),

                  // Selector de Plan
                  const Text(
                    'Seleccionar Plan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),

                  // Usamos FutureBuilder para obtener los planes de Firestore
                  FutureBuilder<List<Plan>>(
                    future: _fetchPlans(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No hay planes disponibles');
                      }

                      // Obtenemos los planes
                      final plans = snapshot.data!;

                      return DropdownButtonFormField<Plan>(
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(13, 71, 161,
                                  1), // Borde azul cuando tiene foco
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey
                                  .shade600, // Borde gris cuando no tiene foco
                              width: 1.0,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        dropdownColor: const Color.fromRGBO(
                            45, 45, 53, 1), // Color de fondo de las opciones
                        value: selectedPlan,
                        hint: const Text(
                          'Selecciona un plan',
                          style: TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(
                            color: Colors
                                .white), // Color del texto de las opciones
                        onChanged: (Plan? newValue) {
                          setState(() {
                            selectedPlan = newValue;
                          });
                        },
                        items: plans.map((Plan plan) {
                          return DropdownMenuItem<Plan>(
                            value: plan,
                            child: Text(
                              '${plan.name} - Q${plan.price}', // Muestra el nombre y el precio
                              style: const TextStyle(
                                  color: Colors
                                      .white), // Color del texto dentro de las opciones
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Campo para el teléfono
                  const Text(
                    'Teléfono',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Ingresa el número de teléfono',
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(13, 71, 161,
                                1)), // Borde azul cuando tiene foco
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),

                  // Campo para el teléfono
                  const Text(
                    'Primer mes Pagado',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: firstPaymonth,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Septiembre 2024',
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(13, 71, 161,
                                1)), // Borde azul cuando tiene foco
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 16),

                  // Campo para el teléfono
                  const Text(
                    'Total primer pago',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: firstPay,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Q 70.00',
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(13, 71, 161,
                                1)), // Borde azul cuando tiene foco
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),

                  SizedBox(height: 40.h),

                  // Botón para guardar
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.group_add_rounded,
                        color: Colors.white70,
                      ),
                      onPressed: _saveClient, // Llama a la función para guardar
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(13, 71, 161, 1),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 20.h),
                      ),
                      label: const Text(
                        'Guardar Cliente',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
