import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:meganetreports/models/incidentsmodel.dart';
import 'package:meganetreports/presentation/screens/info__incidents/head_info.dart';



class InsidentsScreen extends StatelessWidget {
  
  final incidentModel? snapshot;

  const InsidentsScreen({super.key, this.snapshot});

  @override
  Widget build(BuildContext context) {

    DateTime date = DateTime.parse(snapshot!.fecha.toDate().toString());
    

    return Scaffold(
      backgroundColor: const Color.fromRGBO(45, 45, 53, 1),
      appBar: AppBar(
        title: Text('Incidencia', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.grey),),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 71, 161, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            HeadInfo(nombre: snapshot?.cliente, estado: snapshot?.estado),
            SizedBox(height: 10.h,),
            Container(
              padding: EdgeInsets.all(15.0.h),
              child: Row(
                children: [
                  Text('Fecha de creación: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp, color: Colors. white),),
                  SizedBox(width: 20.w,),
                  Text(DateFormat('d/MM/yyyy').format(date), style: TextStyle(color: Colors.white, fontSize: 26.sp),),
                  
                ],
              ),
            ),
            Container(
              padding:  EdgeInsets.all(15.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descripción: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp, color: Colors. white),),
                  SizedBox(width: 20.w,),
                  Text(snapshot!.descripcion, style: TextStyle(color: Colors.white, fontSize: 26.sp),),
                  
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp, color: Colors. white),),
                  SizedBox(width: 20.w,),
                  Text(snapshot!.tipo, style: TextStyle(color: Colors.white, fontSize: 26.sp),),
                  
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0.h),
              //color: Colors.red,
              height: 400.h,
              width: 720.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comentario: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp, color: Colors. white),),
                  SizedBox(width: 20.w,),
                  TextField(
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      //hintText: 'Comentario',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 26.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0.w),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0.w),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ) 
                  
                ],
              ),
            )
          ],
        )
      ),
      extendBody: true,
    /*  bottomNavigationBar:  Stack(
        children: [
          Positioned(
            height: 500.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red[800],
              child: _buildExpandedContent(),
            )
          ),
          //Positioned(child: child)
        ],
      ), */
    );
  }
}

Widget _buildExpandedContent(){
  return Padding(
    padding: EdgeInsets.all(20.h),
    child: Column(
      children: [
        SizedBox(height: 20.h,),
        Text('Comentario', style: TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.bold),),
        TextField(
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration(
            //hintText: 'Comentario',
            hintStyle: TextStyle(color: Colors.white, fontSize: 26.sp),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0.w),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0.w),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        )
      ],
    ),
  );
}
// print text child: Text('Incidencia ${snapshot?.tipo}'),