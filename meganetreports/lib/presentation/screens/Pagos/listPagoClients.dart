import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Listpagoclients extends StatefulWidget {
  const Listpagoclients({super.key});

  @override
  State<Listpagoclients> createState() => _ListpagoclientsState();
}

class _ListpagoclientsState extends State<Listpagoclients> {
  List<Map<String, dynamic>> allClients = [];
  List<Map<String, dynamic>> filteredClients = [];

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  // Función para obtener la lista de clientes de Firestore
  Future<void> _fetchClients() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('clientes').get();
  
  setState(() {
    allClients = snapshot.docs.map((doc) {
      // Aquí incluimos el id del documento junto con los datos
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Añadimos el id al mapa de datos del cliente
      return data;
    }).toList();
    
    filteredClients = allClients; // Inicialmente mostramos todos los clientes
  });
}


  // Filtrar los clientes basados en la búsqueda
  void _filterClients(String query) {
    List<Map<String, dynamic>> filtered = allClients.where((client) {
      return client['nombre'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredClients = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(45, 45, 53, 1),
      appBar: AppBar(
        title: const Text(
          'Cliente Pago',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.h),
        child: Column(
          children: [
            CupertinoSearchTextField(
              placeholder: 'Buscar Cliente',
              style: TextStyle(color: Colors.white60, fontSize: 30.sp),
              itemColor: Colors.white60,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(20.r),
              ),
              onChanged: (value) {
                _filterClients(
                    value); // Llamamos a la función para filtrar los clientes
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: filteredClients.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay clientes disponibles',
                        style: TextStyle(color: Colors.white60),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 37, 37, 37),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.white),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                              onPressed: () {
                                // Aquí manejas la selección del cliente y puedes pasar la info a la pantalla de pago
                                context.go('/home/ListPago/NPago', extra: client['id']); // client['id'] contiene el id del cliente // Enviamos el cliente seleccionado a la pantalla anterior
                              },
                            ),
                            shape: ShapeBorder.lerp(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              1,
                            ),
                            title: Text(
                              client['nombre'] ?? 'Cliente desconocido',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              client['telefono'] ?? 'Sin teléfono',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () {
                              // Aquí manejas la selección del cliente y puedes pasar la info a la pantalla de pago
                              context.go('/home/ListPago/NPago', extra: client['id']); // client['id'] contiene el id del cliente // Enviamos el cliente seleccionado a la pantalla anterior
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
