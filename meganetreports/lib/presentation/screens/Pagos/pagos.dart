import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PagoScreen extends StatelessWidget {
  const PagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        37,
        37,
        37,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Retun(),
            Container(
              height: 1152.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 26, 26),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  const Buscador(),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Infopago(),
                  SizedBox(
                    height: 20.h,
                  ),
                  const InfoClient(),
                  SizedBox(
                    height: 100.h,
                  ),
                  Container(
                    height: 100.h,
                    width: 660.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(35, 122, 252, 1),
                                    Color.fromRGBO(59, 151, 244, 1),
                                  ],
                                ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pagar', style: TextStyle(color: Colors.white60, fontSize: 40.sp, fontWeight: FontWeight.bold),),
                          SizedBox(width: 20.w,),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white60,)
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoClient extends StatelessWidget {
  const InfoClient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: 660.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color.fromARGB(255, 37, 37, 37),
        shape: BoxShape.rectangle,
        boxShadow: //boxsahdow
            const [
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.white12 ,
              child: Icon(
                Icons.person,
                color: Colors.white60,
                size: 50.r,
              ),
            ),
            SizedBox(
              width: 25.w,
            ),
            Text('Paula López', style: TextStyle(color: Colors.white60, fontSize: 35.sp, fontWeight: FontWeight.bold),),
            SizedBox(
              width: 200.w,
            ),
            Icon(
              Icons.delete,
              color: Colors.red[400],
            )
          ],
        ),
      ),
    );
  }
}

class Infopago extends StatelessWidget {
  const Infopago({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.h,
      width: 660.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color.fromARGB(255, 16, 16, 16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text('Plan: Básico',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold
                      )
                    ),
                    Text('Q100.00', style: TextStyle(
                    color: Colors.white60,
                    fontSize: 55.sp,
                    fontWeight: FontWeight.bold
                  ),),
                  ],
                ),
                SizedBox(
                  width: 160.w,
                ),
                Column(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.white60, size: 50.r,),
                    Text('Marzo 2024', style: TextStyle(
                      color: Colors.white60,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ],
            ),
            
            SizedBox(
              height: 15.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Descuento:', style: TextStyle(
                      color: Colors.white60,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(
              height: 5.h,
            ),
            Container(
              width: 300.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.grey[800],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Q 0.00',
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 32.sp),
                    border: InputBorder.none, // Sin borde visible
                    enabledBorder:
                        InputBorder.none, // Para cuando está habilitado
                    focusedBorder:
                        InputBorder.none, // Para cuando está en foco   
                  ),
                  style:const TextStyle(
                      color:
                          Colors.white60), // Para que el texto sea blanco
                ),
              ),
            ),
                  ],
                ),
                SizedBox(
                  width: 75.w,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total:', style: TextStyle(
                      color: Colors.white60,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text('Q100.00', style: TextStyle(
                      color: Colors.green,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                )
            
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

class Buscador extends StatelessWidget {
  const Buscador({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 660.w,
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color.fromARGB(255, 37, 37, 37),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Buscar',
            hintStyle: TextStyle(color: Colors.white38),
            prefixIcon: Icon(Icons.search, color: Colors.white38),
            border: InputBorder.none, // Sin borde visible
            enabledBorder:
                InputBorder.none, // Para cuando está habilitado
            focusedBorder:
                InputBorder.none, // Para cuando está en foco
          ),
          style: TextStyle(
              color:
                  Colors.white60), // Para que el texto sea blanco
        ),
      ),
    );
  }
}

class Retun extends StatelessWidget {
  const Retun({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white60,
          ),
        ),
        SizedBox(
          width: 200.w,
        ),
        Text(
          'Pagos',
          style: TextStyle(
              fontSize: 30.sp,
              color: Colors.white60,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
