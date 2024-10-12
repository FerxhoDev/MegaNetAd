import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Planes extends StatelessWidget {
  const Planes({super.key});

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
      body: Column(
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
                      Text('Plan', style: TextStyle(color: Colors.white70, fontSize: 30.sp, fontWeight: FontWeight.bold)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white70),
                          decoration: InputDecoration(
                           hintText: '"Básico"',
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.wifi,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text('Precio', style: TextStyle(color: Colors.white70, fontSize: 30.sp, fontWeight: FontWeight.bold)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white70),
                          decoration: InputDecoration(
                           hintText: '100',
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.attach_money_sharp,
                              color: Colors.white70,
                            ),
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
                        onPressed: (){}, 
                        child: const Icon(Icons.save, color: Colors.white70,), 
                        backgroundColor: const Color.fromRGBO(35, 122, 252, 1),
                      ),
                    ],
                  ),
                )
              ],   
            ),
          ),
          Container(
            width: double.infinity,
            height: 740.h,
            decoration: const BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 40.w, left: 10.w, right: 10.w),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index){
                  return Card(
                    color: const Color.fromARGB(255, 50, 50, 50),
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: const ListTile(
                      title: Text(
                        'Plan Básico',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '100',
                        style: TextStyle(color: Colors.white60),
                      ),
                      trailing: Icon(
                        Icons.edit,
                        color: Colors.white70,
                      ),
                    ),
                  );
                },
              ),
            )
          )
        ],
        
      )
    );
  }
}