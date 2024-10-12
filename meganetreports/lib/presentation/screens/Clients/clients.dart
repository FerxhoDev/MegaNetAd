import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cliente {
  final String nombre;
  final String plan;
  final bool alDia; // true si está al día, false si no lo está

  Cliente(this.nombre, this.plan, this.alDia);
}

class Clients extends StatelessWidget {
  const Clients({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de clientes de ejemplo
    final List<Cliente> clientes = [
      Cliente('Juan Pérez', 'Plan Básico', true),
      Cliente('Ana García', 'Plan Fast', false),
      Cliente('Carlos Gómez', 'Plan Super Fast', true),
      Cliente('María López', 'Plan Básico', false),
      Cliente('Pedro Rodríguez', 'Plan Fast', true),
      Cliente('Anahí Miranda', 'plan Plus 225', false),
      Cliente('Edgar Paz', 'plan Plus 250', true),
      Cliente('Sofía Mendoza', 'Plan Básico', false),
    ];

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
            child: const TextField(
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                hintText: 'Buscar Cliente',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            // Lista de clientes con ListView.builder
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
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
        onPressed: () {},
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

void main() {
  runApp(MaterialApp(
    home: Clients(),
    builder: (context, child) {
      // Inicializa ScreenUtil para permitir adaptabilidad a diferentes pantallas
      ScreenUtil.init(context, designSize: const Size(375, 812));
      return child!;
    },
  ));
}
