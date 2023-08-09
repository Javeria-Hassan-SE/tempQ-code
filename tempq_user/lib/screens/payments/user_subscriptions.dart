
import 'package:flutter/material.dart';

import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';


class UserSubscriptions extends StatefulWidget {
  const UserSubscriptions({Key? key}) : super(key: key);
  final int index = 8;

  @override
  State<UserSubscriptions> createState() => _UserSubscriptionsState();
}

class _UserSubscriptionsState extends State<UserSubscriptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar(context, "My Subscriptions"),
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context,index){
                return  const Padding(
                  padding: EdgeInsets.only(top:5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.subscriptions),
                      title: Text("Device ID"),
                      subtitle: Text("Active Subscription\n Payment Expiry date"),
                      trailing: Icon(Icons.arrow_forward),
                      isThreeLine: true,
                      iconColor: primaryColor,
                    ),
                  ),
                );

              }

          ),
        )


    );
  }
}