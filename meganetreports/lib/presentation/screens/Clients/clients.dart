import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Cliente {
  final String id;
  final String nombre;

  Cliente(this.id, this.nombre);
}

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  List<Map<String, dynamic>> _allClientes = [];
  List<Map<String, dynamic>> _filteredClientes = [];
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadClientes();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _loadClientes() async {
    try {
      final clientes = await getClientes();
      if (_isMounted) {
        setState(() {
          _allClientes = clientes;
          _filteredClientes = clientes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error loading clientes: $e');
    }
  }

  void _filterClientes(String query) {
    if (_isMounted) {
      setState(() {
        _searchQuery = query;
        if (query.isEmpty) {
          _filteredClientes = _allClientes;
        } else {
          _filteredClientes = _allClientes
              .where((cliente) =>
                  cliente['nombre'].toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    }
  }

  Future<List<Map<String, dynamic>>> getClientes() async {
    List<Map<String, dynamic>> clientes = [];
    
    try {
      QuerySnapshot clientesSnapshot = await FirebaseFirestore.instance
          .collection('clientes')
          .get();

      DateTime fechaActual = DateTime.now();
      String mesActual = '${obtenerNombreMes(fechaActual.month - 1)} ${fechaActual.year}';

      for (var doc in clientesSnapshot.docs) {
        String clientId = doc.id;
        Map<String, dynamic> clientData = doc.data() as Map<String, dynamic>;

        QuerySnapshot pagosSnapshot = await FirebaseFirestore.instance
            .collection('clientes')
            .doc(clientId)
            .collection('Pagos')
            .orderBy('fecha_pago', descending: true)
            .get();

        if (pagosSnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> pagos = pagosSnapshot.docs
              .map((e) => e.data() as Map<String, dynamic>)
              .toList();

          bool estaAlDia = verificarPagosAlDia(pagos, mesActual);
          String ultimoPagoMes = pagos.first['mespago'];

          clientes.add({
            'id': clientId,
            'nombre': clientData['nombre'],
            'ultimoPago': ultimoPagoMes,
            'estaAlDia': estaAlDia,
          });
        } else {
          clientes.add({
            'id': clientId,
            'nombre': clientData['nombre'],
            'ultimoPago': 'Sin pagos',
            'estaAlDia': false,
          });
        }
      }
    } catch (e) {
      print('Error al obtener clientes: $e');
    }

    return clientes;
  }

  bool verificarPagosAlDia(List<Map<String, dynamic>> pagos, String mesActual) {
    if (pagos.isEmpty) return false;

    String ultimoPagoMes = pagos.first['mespago'];
    return compararMeses(ultimoPagoMes, mesActual) >= 0;
  }

  int compararMeses(String mes1, String mes2) {
    List<String> partes1 = mes1.split(' ');
    List<String> partes2 = mes2.split(' ');

    int anio1 = int.parse(partes1[1]);
    int anio2 = int.parse(partes2[1]);

    if (anio1 != anio2) {
      return anio1.compareTo(anio2);
    }

    int indiceMes1 = obtenerIndiceMes(partes1[0]);
    int indiceMes2 = obtenerIndiceMes(partes2[0]);

    return indiceMes1.compareTo(indiceMes2);
  }

  String obtenerMesAnterior(String mes) {
    List<String> partes = mes.split(' ');
    int indiceMes = obtenerIndiceMes(partes[0]);
    int anio = int.parse(partes[1]);

    if (indiceMes == 0) {
      return 'Diciembre ${anio - 1}';
    } else {
      return '${obtenerNombreMes(indiceMes - 1)} $anio';
    }
  }

  int obtenerIndiceMes(String mes) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses.indexOf(mes);
  }

  String obtenerNombreMes(int mes) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes', style: TextStyle(color: Colors.white70),),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              placeholder: 'Buscar cliente',
              style: const TextStyle(color: Colors.white),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              onChanged: _filterClientes,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.blue[700]))
                : _filteredClientes.isEmpty
                    ? const Center(child: Text('No se encontraron clientes', style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                        itemCount: _filteredClientes.length,
                        itemBuilder: (context, index) {
                          var cliente = _filteredClientes[index];
                          return ListTile(
                            leading: Icon(
                              cliente['estaAlDia'] ? Icons.check_circle : Icons.warning,
                              color: cliente['estaAlDia'] ? Colors.green : Colors.orange,
                            ),
                            title: Text(cliente['nombre'], style: const TextStyle(color: Colors.white)),
                            subtitle: Text('Último pago: ${cliente['ultimoPago']}', style: const TextStyle(color: Colors.white70)),
                            onTap: () {
                              context.go('/home/clients/DetalleClients/${cliente['id']}');
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                              onPressed: () => context.go('/home/clients/DetalleClients/${cliente['id']}'),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          context.goNamed('AddClients');
        },
        label: const Text('Agregar Cliente', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.people_alt_outlined, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(35, 122, 252, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}