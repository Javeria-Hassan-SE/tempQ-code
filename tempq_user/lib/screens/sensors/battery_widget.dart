
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class BatteryWidget extends StatefulWidget {
  final double width, height;
  final int voltage;
  const BatteryWidget({Key? key, required this.width, required this.height, required this.voltage}) : super(key: key);

  @override
  State<BatteryWidget> createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.voltage);
    var batteryStatus = widget.voltage.toString();

    print("Voltage"+batteryStatus);
    return Container(
      width: MediaQuery.of(context).size.width/widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column
          (crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(bottom: defaultPadding),
            child: Text("Battery Status",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Stack(
            children: [
              if (widget.voltage >= 60)
                SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      "assets/images/full_battery.gif",
                      fit: BoxFit.cover,
                    )),
              if (widget.voltage < 60 && widget.voltage > 30)
                SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      "assets/images/average_battery.gif",
                      fit: BoxFit.cover,
                    )),
              if (widget.voltage < 30)
                SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      "assets/images/low_battery.gif",
                      fit: BoxFit.cover,
                    )),
              Positioned(
                // The Positioned widget is used to position the text inside the Stack widget
                bottom: 20,
                right: 20,
                child: Container(
                  alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          batteryStatus.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: blackColor),
                        ),
                        const Icon(
                          Icons.electric_bolt,
                          color: yellowColor,
                        )
                      ],
                    )),
              ),
            ],
          ),

        ]));
  }
}
