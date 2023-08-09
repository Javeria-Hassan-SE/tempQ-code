import 'package:flutter/material.dart';
import 'package:tempq_admin/http/delete_request.dart';
import 'package:tempq_admin/http/post_request.dart';
import '../../components/alert_dialog_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../../utils/format_date.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var notifications = SendPostRequest();
  late Future<List<dynamic>> futureSensor;
  var user = UserModel.myUser;
  @override
  initState() {
    super.initState();
    futureSensor = notifications.getSensorNotifications(user.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context, "Notifications"),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              listTile(context)
            ],


        ),
      ),
    );
  }
  Widget listTile(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'You have no notifications',
                  style: TextStyle(fontSize: 16),
                ),
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
                              isThreeLine: true,
                              leading: const Icon(
                                Icons.notifications_active,
                                color: primaryColor,
                              ),
                              trailing: InkWell(
                                onTap: ()  async{
                                  showAlert(data[index]['id']);

                                },
                                child: const Icon(
                                    Icons.delete,
                                    color: Colors.red),
                              ),
                              title: Text(data[index]['title'], style: const TextStyle(fontSize: 14),),
                              subtitle: Text('${data[index]['description']}\n ${FormatDate.formatDateTime(data[index]['time_stamp'])}',
                                  style: const TextStyle(fontSize: 12),),

                            ),
                          ),

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
      future: notifications.getSensorNotifications(user.userId.toString()),
    );
  }
  showMessage(){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Try Later',
          style: TextStyle(fontSize: 16, color: Colors.red),
        )));
  }
  /// Show Alert box before deleting
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
          'Do you want to delete this notification?',
          button1Text: 'No',
          button2Text: 'Yes',
          onPressed1: () {
            Navigator.pop(context);
          },
          onPressed2: () async{
            Navigator.pop(context);
            var msg = await  DeleteRequest.deleteNotification(id);
            if(msg=='Success'){
              setState(() {
                futureSensor = notifications.getSensorNotifications(user.userId.toString());
              });
            }else{
              showMessage();
            }

          },
        ));
  }
}

