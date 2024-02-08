import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoo/constans.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [pink.withOpacity(0.7), grey, white],
                tileMode: TileMode.mirror)),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: TweenAnimationBuilder(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    """Manage your time with """,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    """TODO""",
                    style: TextStyle(fontSize: 30.sp, color: pink),
                  ),
                ],
              ),
              Container(
                height: 320.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/welcomesc.png"),
                )),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  child: Text("Check tasks"))
            ],
          ),
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(seconds: 3),
          builder: (BuildContext context, value, child) {
            return Opacity(
                opacity: value,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: value * 30,
                  ),
                  child: child,
                ));
          },
        ),
      ),
    );
  }
}



/* Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Column(
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    """Manage your time with """,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    """TODO""",
                    style: TextStyle(fontSize: 30.sp, color: pink),
                  ),
                ],
              ),
            
            Container(
              height: 320.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/welcomesc.png"),
              )),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
                child: Text("Check tasks"))
          ],
        ) */


              /* 
              TweenAnimationBuilder(
              child: 
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (BuildContext context, value, child) {
                return Opacity(
                    opacity: value,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: value * 30,
                      ),
                      child: child,
                    ));
              },
            ),
              
              */ 