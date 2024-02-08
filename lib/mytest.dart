import 'package:flutter/material.dart';
import 'package:todoo/sqldb.dart';

class MTest extends StatefulWidget {
  const MTest({super.key});

  @override
  State<MTest> createState() => _MTestState();
}

class _MTestState extends State<MTest> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                print("responssssssssssssssssssssssssssssssssssssse");
                int response = await sqlDb.insertData(
                    "INSERT INTO 'notes' ('note', 'date', 'time') VALUES ('note 3', '2024-01-30', '00:00:00')");
                print(response);
              },
              child: Text("create")),
          ElevatedButton(
              onPressed: () async {
                List<Map<String, Object?>> response =
                    await sqlDb.readData("SELECT * FROM 'notes'");
                print(response);
              },
              child: Text("read")),
          ElevatedButton(
              onPressed: () async {
                int response = await sqlDb.updateData(
                    "UPDATE 'notes' SET 'note' = 'new note' WHERE id = 2");
                print(response);
              },
              child: Text("update")),
          ElevatedButton(
              onPressed: () async {
                int response =
                    await sqlDb.deleteData("DELETE FROM 'notes' WHERE id = 2");
                print(response);
              },
              child: Text("delete")),
        ],
      ),
    );
  }
}
