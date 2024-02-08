import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoo/constans.dart';
import 'package:intl/intl.dart';
import 'package:todoo/sqldb.dart';

class CreateNew extends StatefulWidget {
  const CreateNew({Key? key}) : super(key: key);

  @override
  State<CreateNew> createState() => _CreateNewState();
}

class _CreateNewState extends State<CreateNew> {
  DateFormat dateFormat = DateFormat('d MMM');

  TextEditingController nameConroller = TextEditingController();
  TextEditingController descriptionConroller = TextEditingController();
  DateTime currentDate = DateTime.now();
  DateTime? _selectedDate;
  //TimeOfDayFormat timeFormate = TimeOfDayFormat.HH_dot_mm;
  TimeOfDay? _selectedTime;
  String? timeFormated;
  String? DateFormated;
  bool inputerror = false;
  SqlDb sqldb = SqlDb();

  bool arugs = false;
  int realid = 1;
//final String name ='No name';

  @override
  void didChangeDependencies() {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String name = args?['name'] ?? 'No name';
    final String date = args?['date'] ?? 'No date';
    final String time = args?['time'] ?? 'No time';
    final String description = args?['description'] ?? 'No description';
    final String id = args?['id'] ?? "1";

    realid = int.parse(id);

    if (args != null) {
      arugs = true;
      nameConroller.text = name;
      DateFormated = date;
      timeFormated = time;
      descriptionConroller.text = description;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [pink.withOpacity(0.7), grey, white],
                  tileMode: TileMode.mirror)),
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 300.w,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30.sp,
                          color: blue,
                        )),
                  )),
              inputerror
                  ? const Text(
                      "please enter all inputs data !",
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              myTextfield(context, nameConroller, " Task name *", 11),
              myTextfield(context, descriptionConroller, " description", 80),

              // MyTextField(controller: nameConroller),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 200.w,
                      child: Text(
                        "when?",
                        style: TextStyle(backgroundColor: pink),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DateFormated == null
                          ? Container(
                              width: 120.w,
                              child: Text(
                                "select date:",
                                style: TextStyle(color: yellow, fontSize: 25),
                              ))
                          : Container(
                              width: 120.w,
                              child: Text(
                                DateFormated!,
                                //dateFormat.format(_selectedDate!),
                                style: TextStyle(
                                    color: yellow,
                                    fontSize: 25,
                                    decorationStyle: TextDecorationStyle.double,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                      IconButton(
                          onPressed: () async {
                            await showDatePicker(
                                    context: context,
                                    initialDate: currentDate,
                                    firstDate: currentDate,
                                    lastDate: DateTime(2026))
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  _selectedDate = value;
                                  DateFormated =
                                      dateFormat.format(_selectedDate!);
                                  //_selectedDate.
                                });
                              }
                            });
                          },
                          icon: Icon(
                            Icons.date_range_outlined,
                            color: blue,
                            size: 35,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      timeFormated == null
                          ? Container(
                              width: 120.w,
                              child: Text(
                                "select Time:",
                                style: TextStyle(color: yellow, fontSize: 25),
                              ),
                            )
                          : Container(
                              width: 120.w,
                              child: Text(
                                // "${_selectedTime!.format(context)} ",
                                timeFormated!,
                                style: TextStyle(
                                    color: yellow,
                                    fontSize: 25,
                                    decorationStyle: TextDecorationStyle.double,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                      IconButton(
                          onPressed: () async {
                            final DateTime? DatePacked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  _selectedTime = value;
                                  timeFormated = _selectedTime!.format(context);
                                });
                              }
                            });
                          },
                          icon: Icon(
                            Icons.watch_later_outlined,
                            color: blue,
                            size: 35,
                          )),
                    ],
                  ),
                ],
              ),

              arugs
                  ? ElevatedButton(
                      onPressed: () async {
                        if (nameConroller.text.trim() == "" ||
                            DateFormated == null ||
                            timeFormated == null) {
                          setState(() {
                            inputerror = true;
                          });
                        } else {
                          int response = await sqldb.updateData(
                              '''UPDATE notes SET note = '${nameConroller.text.trim()}', date='$DateFormated', time='$timeFormated',description = '${descriptionConroller.text.trim()}'  WHERE id = $realid''');
                          print(response);
                          if (response > 0) {
                            Navigator.pushReplacementNamed(context, "/home");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: pink),
                      child:
                          Text("Update task", style: TextStyle(color: white)),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        // print(notesList);

                        if (nameConroller.text.trim() == "" ||
                            DateFormated == null ||
                            timeFormated == null) {
                          setState(() {
                            inputerror = true;
                          });
                        } else {
                          int response = await sqldb.insertData(
                              '''INSERT INTO 'notes' (`note`,`date`,`time`,`description`) VALUES ('${nameConroller.text.trim()}', '$DateFormated', '$timeFormated','${descriptionConroller.text.trim()}')''');
                          print(response);
                          if (response > 0) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(context, "/home");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: pink),
                      child:
                          Text("create task", style: TextStyle(color: white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Padding myTextfield(BuildContext context, TextEditingController controll,
      String labletext, int max) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      child: TextField(
        maxLength: max,
        controller: controll,
        style:
            Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.sp),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: blue, width: 3, strokeAlign: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: blue, width: 3, strokeAlign: 2)),
            fillColor: grey,
            filled: true,
            labelText: labletext,
            labelStyle: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
