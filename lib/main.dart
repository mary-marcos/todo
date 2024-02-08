import 'package:flutter/material.dart';
import 'package:todoo/constans.dart';
import 'package:todoo/mytest.dart';
import 'package:todoo/screens/home_sc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:todoo/screens/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(300, 650),
      splitScreenMode: true,
      //minTextAdapt: true,

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: blue),
          textTheme:
              TextTheme(bodyMedium: TextStyle(color: blue, fontSize: 20)),
          useMaterial3: true,
        ),
        routes: myroutes,
        // home: rou
        //Home(),
      ),
    );
  }
}
