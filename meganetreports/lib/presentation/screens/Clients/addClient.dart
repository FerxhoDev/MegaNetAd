import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddClients extends StatefulWidget {
  const AddClients({super.key});

  @override
  State<AddClients> createState() => _AddClientsState();
}

class _AddClientsState extends State<AddClients> {
  // Controladores de los campos
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Variable para almacenar el plan seleccionado
  String? selectedPlan;

  // Lista de planes disponibles
  final List<String> plans = ['Plan Básico', 'Plan Premium', 'Plan Empresarial'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(45, 45, 53, 1),
      appBar: AppBar(
        title: const Text('Agregar Cliente', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                decoration: const BoxDecoration(
                  color:  Color.fromARGB(255, 37, 37, 37),
                  borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color:  Color.fromRGBO(13, 71, 161, 1),
                      spreadRadius: .5,                                      
                      blurRadius: 15,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    // Campo para el nombre del cliente
                    const Text(
                      'Nombre',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),                                                   
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
                          borderSide: BorderSide(color:Color.fromRGBO(13, 71, 161, 1),) // Borde azul cuando tiene foco
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,),
                    

                    ),
                    const SizedBox(height: 16),
                        
                    // Selector de Plan
                    const Text(
                      'Seleccionar Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        
                        // Cambiar el borde al dar focus (activo)
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(13, 71, 161, 1), // Borde azul cuando tiene foco
                          ),
                        ),

                        // Cambiar el borde cuando no tiene focus
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            
                            color: Colors.grey.shade600, // Borde gris cuando no tiene foco
                            width: 1.0,
                          ),
                        ),

                        // Resto del estilo
                        border: const OutlineInputBorder(),
                      ),

                      dropdownColor: const Color.fromRGBO(45, 45, 53, 1), // Color de fondo de las opciones

                      value: selectedPlan,
                      hint: const Text(
                        'Selecciona un plan',
                        style: TextStyle(color: Colors.grey),
                      ),

                      style: const TextStyle(color: Colors.white), // Color del texto de las opciones

                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPlan = newValue;
                        });
                      },

                      items: plans.map((String plan) {
                        return DropdownMenuItem<String>(
                          value: plan,
                          child: Text(
                            plan,
                            style: const TextStyle(color: Colors.white), // Color del texto dentro de las opciones
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                        
                    // Campo para el teléfono
                    const Text(
                      'Teléfono',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
                          borderSide: BorderSide(color:Color.fromRGBO(13, 71, 161, 1),) // Borde azul cuando tiene foco
                        ),
                      ),
                    ),
                    SizedBox(height: 60.h),
                        
                    // Botón para guardar
                    Center(
                      child: ElevatedButton.icon(
                        
                        icon: const Icon(
                          Icons.group_add_rounded,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          // Aquí puedes manejar la lógica para guardar los datos
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cliente Agregado')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(13, 71, 161, 1),
                          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                        ),
                        label: const Text(
                          'Guardar Cliente',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ),                   
                    ),
                    SizedBox(height: 60.h,),
                  ],
                ),
              ),
            ],
          ),
      )
    );
  }
}
