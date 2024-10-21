import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Plan {
  final String name;
  final String price;

  Plan({required this.name, required this.price});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Plan &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}


class EditarCliente extends StatefulWidget {
  final String clientId;
  final Map<String, dynamic> clientData;

  const EditarCliente({Key? key, required this.clientId, required this.clientData}) : super(key: key);

  @override
  _EditarClienteState createState() => _EditarClienteState();
}

class _EditarClienteState extends State<EditarCliente> {
  late TextEditingController _nombreController;
  late TextEditingController _telefonoController;
  late TextEditingController _planNombreController;
  late TextEditingController _planPrecioController;


  // Variable para almacenar el plan seleccionado
  Plan? selectedPlan;

// Método para obtener los planes de Firestore
  Future<List<Plan>> _fetchPlans() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('planes').get();
    return snapshot.docs.map((doc) {
      return Plan(
        name: doc['nombre'] as String,
        price: doc['precio'] as String,
      );
    }).toList();
  }


  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.clientData['nombre']);
    _telefonoController = TextEditingController(text: widget.clientData['telefono']);
    _planNombreController = TextEditingController(text: widget.clientData['plan_nombre']);
    _planPrecioController = TextEditingController(text: widget.clientData['plan_precio'].toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _planNombreController.dispose();
    _planPrecioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    await FirebaseFirestore.instance.collection('clientes').doc(widget.clientId).update({
      'nombre': _nombreController.text,
      'telefono': _telefonoController.text,
      'plan_nombre': selectedPlan!.name,
      'plan_precio': selectedPlan!.price,
    });
    Navigator.of(context).pop();  // Cierra la pantalla al guardar los cambios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        title: const Text('Editar Cliente',style: TextStyle(color: Colors.white70)),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        iconTheme: const IconThemeData(color: Colors.white70),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                 focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(13, 71, 161, 1)), // Borde azul cuando tiene foco
                      ),
              ),
              style: const TextStyle(color: Colors.white70),  
            ),
              const SizedBox(height: 8),
            const Text(
              'Teléfono',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              const SizedBox(height: 8),
            TextField(
              controller: _telefonoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                 focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(13, 71, 161, 1)), // Borde azul cuando tiene foco
                      ),
              ),
              style: const TextStyle(color: Colors.white70),  
            ),
              const SizedBox(height: 8),
            const Text(
                    'Seleccionar Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
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
                              color: Color.fromRGBO(13, 71, 161, 1), // Borde azul cuando tiene foco
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey.shade600, // Borde gris cuando no tiene foco
                              width: 1.0,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        dropdownColor: const Color.fromRGBO(45, 45, 53, 1), // Color de fondo de las opciones
                        value: selectedPlan,
                        hint: const Text(
                          'Selecciona un plan',
                          style: TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(color: Colors.white), // Color del texto de las opciones
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
                              style: const TextStyle(color: Colors.white), // Color del texto dentro de las opciones
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Center(
  child: ElevatedButton.icon(
    onPressed: () {
      // Muestra el AlertDialog al presionar el botón
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Icon(Icons.edit, color:Color.fromRGBO(35, 122, 252, 1)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            title: const Text('Confirmar  Cambios', style: TextStyle(color: Colors.white)),
            content: const Text('¿Estás seguro de que deseas guardar los cambios?', style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  // Cierra el AlertDialog sin hacer nada
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar', style: TextStyle(color: Colors.blue),),
              ),
              TextButton(
                onPressed: () async {
                  // Llama a _saveChanges y espera a que se complete
                  await _saveChanges();

                  // Cierra el AlertDialog después de guardar
                  Navigator.of(context).pop();

                  // Muestra un mensaje opcional o navega de regreso si es necesario
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cambios guardados exitosamente')),
                  );

                  // Regresa a la pantalla anterior si así lo deseas
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    },
    icon: const Icon(Icons.save, color: Colors.white),
    label: const Text('Guardar Cambios', style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(13, 71, 161, 1), // Color azul
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
