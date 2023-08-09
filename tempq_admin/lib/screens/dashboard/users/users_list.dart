import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tempq_admin/screens/dashboard/users/add_new_admin.dart';

import '../../../components/defaultAppBar.dart';
import '../../../constants/constants.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late List data = [];

  /// Function to get the data from the database
  Future<String> getData() async {
    /// Make a HTTP GET request to the PHP script
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/get_all_users.php');
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var msg = json.decode(response.body);
    if (msg == "Error") {
      return "Error";
    } else {
      setState(() {
        data = json.decode(response.body);
      });
      // Return a response
      return "Success";
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the getData function when the app starts
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context, "Users"),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: data == []
                  // Show a loading spinner while the data is being retrieved
                  ? const Center(child: Text('No User Found'))
                  // Build the DataTable widget with the retrieved data
                  : Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Contact")),
                          DataColumn(label: Text("Location")),
                          DataColumn(label: Text("User Type")),
                        ],
                        rows: data
                            .map((item) => DataRow(
                                  cells: [
                                    DataCell(Text(item["user_id"])),
                                    DataCell(Text(item["user_full_name"])),
                                    DataCell(Text(item["user_email"])),
                                    DataCell(Text(item["user_contact"])),
                                    DataCell(Text(item["user_location"])),
                                    DataCell(Text(item["user_type"])),
                                  ],
                                ))
                            .toList(),
                      ),
                    ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  AddNewAdmin(),
            ),
          ).then((onGoBack));
        },
        child: const Icon(
          Icons.add,
          color: secondaryColor,
        ),
      ),
    );
  }
  FutureOr onGoBack(dynamic value) {
    setState(() {
      getData();
    });
  }
}
