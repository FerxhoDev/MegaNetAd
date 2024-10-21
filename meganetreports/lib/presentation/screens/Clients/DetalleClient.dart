import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Detalleclient extends StatefulWidget {
  final String clientId;
  const Detalleclient({Key? key, required this.clientId}) : super(key: key);

  @override
  State<Detalleclient> createState() => _DetalleclientState();
}

class _DetalleclientState extends State<Detalleclient> {
  Stream<QuerySnapshot>? _pagosStream;

  @override
  void initState() {
    super.initState();
    _pagosStream = FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.clientId)
        .collection('Pagos')
        .orderBy('fecha_pago', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        title: const Text('Detalle Cliente', style: TextStyle(color: Colors.white70)),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        iconTheme: const IconThemeData(color: Colors.white70),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('clientes').doc(widget.clientId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white70)));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('No se encontró el cliente', style: TextStyle(color: Colors.white70)));
                  }

                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  return Card(
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre: ${data['nombre']}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                          Text('Plan: ${data['plan_nombre']}', style: const TextStyle(color: Colors.white70)),
                          Text('Precio: \Q${data['plan_precio']}', style: const TextStyle(color: Colors.white70)),
                          Text('Teléfono: ${data['telefono']}', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('Historial de Pagos', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: _pagosStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white70)));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No hay pagos registrados', style: TextStyle(color: Colors.white70)));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var pago = snapshot.data!.docs[index];
                      return Card(
                        color: Colors.grey[850],
                        child: ListTile(
                          title: Text('Mes: ${pago['mespago']}', style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format((pago['fecha_pago'] as Timestamp).toDate())}\nTotal: \Q${pago['total']}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70),
                            onPressed: () {
                              // Aquí iría la lógica para editar el pago
                              print('Editar pago: ${pago.id}');
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}