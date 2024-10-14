import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Planes extends StatefulWidget {
  @override
  _PlanesState createState() => _PlanesState();
}

class _PlanesState extends State<Planes> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Método para guardar los planes en Firestore
  Future<void> _savePlan() async {
    String nombre = nameController.text;
    String precio = priceController.text;

    if (nombre.isNotEmpty && precio.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('planes').add({
          'nombre': nombre,
          'precio': precio,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plan guardado exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el plan: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
    }

    nameController.clear();
    priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white70),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        title: const Text(
          'Planes',
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 400.h,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30.w),
                    width: 500.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'Nombre',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 50, 50, 50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              hintText: 'Básico',
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Precio',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 50, 50, 50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              hintText: 'Q 100',
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 220.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: _savePlan, // Llama al método para guardar el plan
                          child: const Icon(
                            Icons.save,
                            color: Colors.white70,
                          ),
                          backgroundColor: const Color.fromRGBO(35, 122, 252, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 740.h,
              decoration: const BoxDecoration(
                color: Color.fromARGB(209, 56, 56, 56),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 40.w, left: 10.w, right: 10.w),
                // Usamos StreamBuilder para obtener los planes de Firestore
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('planes').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final planes = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: planes.length,
                      itemBuilder: (context, index) {
                        var planData = planes[index].data() as Map<String, dynamic>;
                        String nombre = planData['nombre'];
                        String precio = planData['precio'];

                        return Card(
                          color: const Color.fromARGB(255, 37, 37, 37),
                          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child: ListTile(
                            title: Text(
                              nombre,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Precio: Q$precio',
                              style: const TextStyle(color: Colors.white60),
                            ),
                            trailing: const Icon(
                              Icons.edit,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
