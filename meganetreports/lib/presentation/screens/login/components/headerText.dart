import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 312.h,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Iniciar Sesión', style: TextStyle(color: Colors.white, fontSize:70.sp, fontWeight: FontWeight.bold),),
          SizedBox(height: 10.w,),
          Text('Bienvenido de nuevo', style: TextStyle(color: Colors.white, fontSize: 25.sp),)
        ],
      ),
    );
  }
}