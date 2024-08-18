import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadInfo extends StatelessWidget {
  final String? nombre;
  final bool? estado;

  const HeadInfo({
    super.key,
    this.nombre,this.estado
  });

  @override
  Widget build(BuildContext context) {

    Color iconColor = estado! ? Colors.green : Colors.red;

    IconData icon =
        estado! ? Icons.wifi : Icons.wifi_off_rounded;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromRGBO(13, 71, 161, 1),
                Color.fromRGBO(45, 45, 53, 1),
              ]
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          height: 200.h,
          width: 800.w,
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    nombre!,
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  Icon(icon, color: iconColor, size: 60.sp,),
                ],
              )
            )
          ),
    );
  }
}
