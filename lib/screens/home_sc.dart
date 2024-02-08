import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoo/constans.dart';
import 'package:todoo/screens/createNew.dart';
import 'package:todoo/sqldb.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqldb = SqlDb();
  List notesList = [];
  bool loading = true;
  //late bool ischeckeded;
  Map<int, bool> checkboxStates = {};
  Future readDta() async {
    List<Map> response = await sqldb.readData("SELECT * FROM 'notes'");
    notesList.addAll(response);
    loading = false;
    if (this.mounted) {
      setState(() {
        checkboxStates = Map.fromIterable(
          notesList,
          key: (item) => item['id'],
          value: (item) => item['done'] == 1,
        );
      });
    }

    return response;
  }

  @override
  void initState() {
    readDta();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: Text("LOADING...."))
          : notesList.isEmpty
              ? Center(
                  child: Container(
                    child: Text(
                      "No Tasks TODO !",
                      style: TextStyle(
                          color: pink,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  color: white,
                  child: Center(
                    child: TweenAnimationBuilder(
                      child: Container(
                        height: MediaQuery.sizeOf(context).height,
                        child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return taskItem(
                                index: index,
                                onpressedit: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/CreateNew",
                                    arguments: {
                                      'name': "${notesList[index]['note']}",
                                      'date': "${notesList[index]['date']}",
                                      'time': "${notesList[index]['time']}",
                                      'id': "${notesList[index]['id']}",
                                      'description':
                                          "${notesList[index]['description']}",
                                    },
                                  );
                                },
                                onpress: () async {
                                  print("${notesList}");
                                  int response = await sqldb.deleteData(
                                      "DELETE FROM 'notes' WHERE id = ${notesList[index]['id']}");
                                  if (response > 0) {
                                    notesList.removeWhere((element) =>
                                        element['id'] ==
                                        notesList[index]['id']);
                                    setState(() {});
                                  }
                                },
                                name: "${notesList[index]['note']}",
                                date: "${notesList[index]['date']}",
                                time: "${notesList[index]['time']}",
                                description:
                                    "${notesList[index]['description']}");
                          },
                          itemCount: notesList.length,
                        ),
                      ),
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
                  ),
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(notesList);
            Navigator.pushNamed(context, "/CreateNew");
            //await sqldb.deleteAllDatabase();

            //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNew(),));
          },
          child: Icon(Icons.add, color: white),
          backgroundColor: pink),
    );
  }

  Widget taskItem(
      {required String name,
      required String date,
      required String time,
      required int index,
      required String description,
      // required bool ischecked,
      required void Function()? onpress,
      required void Function()? onpressedit}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 15,

        // color: grey,

        child: CheckboxListTile(
          onChanged: (bool? val) async {
            int updatedValue = val == true ? 1 : 0;
            int response = await sqldb.updateData(
                "UPDATE 'notes' SET done = ${val == true ? 1 : 0} WHERE id = ${notesList[index]['id']}");
            // List<Map<String, dynamic>> updatedList = List.from(notesList);
            //updatedList[index]['done'] = val == true ? 1 : 0;
            setState(() {
              checkboxStates[notesList[index]['id']] = val == true;

              print("changed   $val"); // Update the state variable
            });
          },
          value: checkboxStates[notesList[index]['id']] ?? false,
          secondary: Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r), color: blue),
            child: Column(
              children: [
                Icon(
                  Icons.date_range,
                  color: white,
                  size: 25.sp,
                ),
                Text(
                  date,
                  style: TextStyle(color: yellow, fontSize: 13.sp),
                ),
              ],
            ),
          ),

          title: Column(
            children: [
              Text(name, style: TextStyle(color: blue)),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: yellow,
                      ),
                      Text(
                        time,
                        style: TextStyle(color: yellow),
                      )
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Details"),
                              content: description == ""
                                  ? Column(
                                      children: [
                                        Text("No detailed information "),
                                        TextButton(
                                          onPressed: onpressedit,
                                          child: Text(
                                            "add details ? ",
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: pink,
                                                decorationStyle:
                                                    TextDecorationStyle.wavy,
                                                decoration:
                                                    TextDecoration.combine([
                                                  TextDecoration.underline,
                                                  TextDecoration.underline
                                                ])),
                                          ),
                                        )
                                      ],
                                    )
                                  : Text(description),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "details",
                        style: TextStyle(
                            fontSize: 10.sp,
                            decoration: TextDecoration.underline),
                      ))
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: onpressedit,
                      icon: Icon(
                        Icons.edit,
                        color: blue,
                      )),
                  IconButton(
                      onPressed: onpress,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              )
            ],
          ),
          tileColor: grey,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.r))),

          side: BorderSide(color: blue),
          activeColor: pink, // Set the color of the checkbox when it is checked
          checkColor: white,
        ),
      ),
    );
  }
}

















/*

Container(
                  height: 360.h,
                  child: ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return taskItem(
                          index: index,
                          onpressedit: () {
                            Navigator.pushNamed(
                              context,
                              "/CreateNew",
                              arguments: {
                                'name': "${notesList[index]['note']}",
                                'date': "${notesList[index]['date']}",
                                'time': "${notesList[index]['time']}",
                                'id': "${notesList[index]['id']}",
                                'description':
                                    "${notesList[index]['description']}",
                              },
                            );
                          },
                          onpress: () async {
                            print("${notesList}");
                            int response = await sqldb.deleteData(
                                "DELETE FROM 'notes' WHERE id = ${notesList[index]['id']}");
                            if (response > 0) {
                              notesList.removeWhere((element) =>
                                  element['id'] == notesList[index]['id']);
                              setState(() {});
                            }
                          },
                          name: "${notesList[index]['note']}",
                          date: "${notesList[index]['date']}",
                          time: "${notesList[index]['time']}",
                          description: "${notesList[index]['description']}");
                    },
                    itemCount: notesList.length,
                  ),
                ),
*/