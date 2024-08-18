import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meganetreports/models/incidentsmodel.dart';
import 'package:meganetreports/presentation/screens/home/components/headerWithButtonCreate.dart';
import 'package:meganetreports/presentation/screens/home/components/tittleWithButtonSeeMore.dart';
import 'package:meganetreports/services/firebase_service.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final bool isEneabled = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderwithButtonCreate(size: size),
          SizedBox(height: 20.h),
          //body con fondo oscuro
          const TitleWhitButton(),
          SizedBox(height: 20.h),
          // container with cards info

          Container(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              width: size.width,
              height: 360.h,
              child: FutureBuilder(
                future: getIncidents(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        bool estado = snapshot.data?[index]['estado'] ?? false;

                        Color iconColor = estado ? Colors.green : Colors.red;

                        IconData icon =
                            estado ? Icons.wifi : Icons.wifi_off_rounded;

                        incidentModel data = incidentModel(
                            cliente: snapshot.data?[index]['cliente'],
                            tipo: snapshot.data?[index]['tipo'],
                            descripcion: snapshot.data?[index]['descripcion'],
                            comentario: snapshot.data?[index]['comentario'],
                            estado: snapshot.data?[index]['estado'],
                            fecha: snapshot.data?[index]['fechacrea']
                          );
                        return ListTile(
                          onTap: () {
                            context.goNamed('info_incidents',
                            extra: data,
                            );
                          },
                          style: ListTileStyle.list,
                          textColor: Colors.white,
                          title: Text(
                            snapshot.data?[index]['tipo'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(snapshot.data?[index]['cliente']),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          leading: Icon(
                            icon,
                            color: iconColor,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
              ))
        ],
      ),
    );
  }
}
