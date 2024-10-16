import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Cliente {
  final String id;
  final String nombre;
  final String plan;
  final bool alDia; // true si está al día, false si no lo está

  Cliente(this.id, this.nombre, this.plan, this.alDia);
}


class Clients extends StatefulWidget {
  const Clients({super.key});
  

  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {

  
  List<Cliente> clientes = [];
  List<Cliente> filteredClientes = []; // Lista para filtrar los clientes
  String searchQuery = ''; // Consulta de búsqueda

  @override
  void initState() {
    super.initState();
    _getClientes(); // Llama la función para obtener los clientes
  }

  Future<void> _getClientes() async {
    List<Cliente> fetchedClientes = [];

    try {
      // Obtener todos los clientes
      QuerySnapshot clientesSnapshot = await FirebaseFirestore.instance.collection('clientes').get();

      // Obtener el mes actual
      DateTime now = DateTime.now();
      int currentMonth = now.month;

      for (var doc in clientesSnapshot.docs) {
        String idCliente = doc.id;
        String nombre = doc['nombre'];
        String plan = doc['plan_nombre'];

        // Verificar los pagos de la subcolección Pagos para este cliente
        QuerySnapshot pagosSnapshot = await FirebaseFirestore.instance
            .collection('clientes')
            .doc(idCliente)
            .collection('Pagos')
            .where('mespago', isEqualTo: currentMonth.toString()) // Filtrar por mes actual
            .get();

        // Determinar si está al día
        bool alDia = pagosSnapshot.docs.isNotEmpty;

        // Crear la instancia de Cliente
        fetchedClientes.add(Cliente(idCliente, nombre, plan, alDia));
      }
    } catch (e) {
      print('Error al obtener clientes: $e');
    }

    setState(() {
      clientes = fetchedClientes;
      filteredClientes = fetchedClientes; // Inicialmente muestra todos los clientes
    });
  }

  void _filterClientes(String query) {
    final filtered = clientes.where((cliente) {
      return cliente.nombre.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredClientes = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white70),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        title: const Text(
          'Clientes',
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 50, 50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CupertinoSearchTextField(
              backgroundColor: Colors.transparent,
              placeholder: 'Buscar cliente',
              style: const TextStyle(color: Colors.white70),
              onChanged: _filterClientes, // Filtra clientes cuando cambia el texto
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            // Lista de clientes con ListView.builder
            child: ListView.builder(
              itemCount: filteredClientes.length,
              itemBuilder: (context, index) {
                final cliente = filteredClientes[index];
                return Card(
                  color: const Color.fromARGB(255, 50, 50, 50),
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: ListTile(
                    title: Text(
                      cliente.nombre,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      cliente.plan,
                      style: const TextStyle(color: Colors.white60),
                    ),
                    trailing: Icon(
                      cliente.alDia ? Icons.check_circle : Icons.warning,
                      color: cliente.alDia ? Colors.green : Colors.orange,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(13, 71, 161, 1),
        ),
        onPressed: () {
          context.goNamed('AddClients');
        },
        label: const Text(
          'Agregar Cliente',
          style: TextStyle(color: Colors.white60),
        ),
        icon: const Icon(
          Icons.group_add_rounded,
          color: Colors.white70,
        ),
      ),
    );
  }
}
