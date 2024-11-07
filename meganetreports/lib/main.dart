import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meganetreports/Provider/appProvider.dart';
import 'package:meganetreports/config/router/app_router.dart';
import 'package:provider/provider.dart';



void main () async{
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBObzqk5VnhNrtaM99N0PkuYwHZIEkkd0g', 
      appId: '1:556115136457:android:15cb0f791045fc72e3a218', 
      messagingSenderId: '556115136457', 
      projectId: 'menanetrepots'
    )
  )


  :await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviders()),
      ],
      child:
    const MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(720, 1280),
      builder: (_, child){
        return MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          title: 'MegaNet',
          theme: ThemeData(                                            
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}

