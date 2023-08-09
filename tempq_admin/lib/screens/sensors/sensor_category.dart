import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tempq_admin/http/delete_request.dart';
import 'package:tempq_admin/http/post_request.dart';
import '../../components/alert_dialog_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import 'add_new_category.dart';

class SensorCategory extends StatefulWidget {
  const SensorCategory({Key? key}) : super(key: key);
  @override
  State<SensorCategory> createState() => _SensorCategoryState();
}

class _SensorCategoryState extends State<SensorCategory> {
   var categories = SendPostRequest();
  late Future<List<dynamic>> futureSensor;

  @override
  initState() {
    super.initState();
    futureSensor = categories.getSensorCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar(context, "Sensors Category"),
        body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listTile(context),
                ])),
      floatingActionButton: FloatingActionButton(
      backgroundColor: greenColor,
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>
          const AddNewCategory(),
          ),
        ).then((onGoBack));
      },
      child: const Icon(Icons.add, color: secondaryColor,),
    ),
    );
  }
  FutureOr onGoBack(dynamic value) {
    setState(() {
      futureSensor = categories.getSensorCategory();
    });
  }
  Widget listTile(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Currently You have no Device',
                style: TextStyle(fontSize: 16),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data;
            if (data != null) {
              return Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        InkWell(
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(
                                Icons.sensors,
                                color: Colors.green,
                              ),
                              trailing: const Icon(
                                  Icons.delete_outlined,
                                  color: Colors.red),
                              title: Text(data[index]),

                            ),
                          ),
                          onTap: () async {
                            showAlert(data[index]);
                          },
                        );

                    }),
              );
            }
          }
        }
        // Displaying LoadingSpinner to indicate waiting state
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: categories.getSensorCategory(),
    );
  }

  showMessage(){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Some user has register his device with this category, so cannot delete this category',
          style: TextStyle(fontSize: 16, color: Colors.red),
        )));
  }

  showAlert(String id){
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          icon: const Icon(
            Icons.close,
            size: 40,
            color: Colors.red,
          ),
          text: 'Delete',
          content:
          'Do you want to delete this category?',
          button1Text: 'No',
          button2Text: 'Yes',
          onPressed1: () {
            Navigator.pop(context);
          },
          onPressed2: () async{
            Navigator.pop(context);
            var msg = await DeleteRequest.callDeleteFunction(id);
            if(msg=='Success'){
              setState(() {
                futureSensor = categories.getSensorCategory();

              });
            }else{
              showMessage();
            }
          },
        ));
  }

}
