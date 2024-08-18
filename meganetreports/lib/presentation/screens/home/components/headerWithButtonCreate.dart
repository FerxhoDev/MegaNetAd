import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderwithButtonCreate extends StatefulWidget {
  const HeaderwithButtonCreate({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<HeaderwithButtonCreate> createState() => _HeaderwithButtonCreateState();
}

class _HeaderwithButtonCreateState extends State<HeaderwithButtonCreate> {

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 315.h,
      child: Stack(
        children: [
          //Container for he User Info
          Container(
            height: 270.h ,
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 36),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(''+ user.email!, style: TextStyle(fontSize:30.sp, color: Colors.grey[300], )),
                          Text('Welcome', style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold, color: Colors.grey[300]),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.size.width * 0.2,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: 15.w,),
                          Text('Mega', style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.blue, shadows: const [ Shadow(blurRadius:6, color: Colors.grey, offset: Offset(5.0, 5.0),)]), ),
                          Text('Net', style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.red, shadows: const [Shadow(blurRadius: 6, color: Colors.grey, offset: Offset(5.0, 5.0),)]), ),
                        
                        ],
                      ),
                      //backgroundImage: AssetImage('images/LogoMN3.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 110),
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.red[800],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 12,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('New Incident', style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: Colors.white), ),
                const Icon(Icons.add_circle_outlined, size: 25, color: Colors.white),
              ],
              ),
            ),
          )
        ],
      ),
    );
  }
}