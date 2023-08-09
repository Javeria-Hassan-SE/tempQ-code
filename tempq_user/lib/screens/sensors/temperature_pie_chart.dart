
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../constants/constants.dart';

class TemperaturePieChart extends StatefulWidget {
  final double width, height, tempValue;
  const TemperaturePieChart({Key? key, required this.width, required this.height, required this.tempValue}) : super(key: key);

  @override
  State<TemperaturePieChart> createState() => _TemperaturePieChartState();
}
class _TemperaturePieChartState extends State<TemperaturePieChart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var tempNeedle = widget.tempValue;
    var temp = widget.tempValue.toString();
    double tempRange = 40;
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width/widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const Text("Current Temperature", style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
          Flexible(
            child:
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  axisLabelStyle:const GaugeTextStyle(fontSize:8),
                  minimum: -tempRange,
                  maximum: tempRange+0.1,
                  startAngle: 180,
                  endAngle: 0,
                  canScaleToFit: true,
                  interval: 10,
                  majorTickStyle:const MajorTickStyle(length: 0.1, thickness: 0.1, lengthUnit: GaugeSizeUnit.factor,
                      ),
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: -tempRange, endValue: tempRange, color: Colors.blue, startWidth: 10, endWidth: 10),

                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(value: tempNeedle, needleEndWidth: 5, animationDuration: 1000),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text('$temp °F', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      angle: 90,
                      positionFactor: 0.4,
                    ),
                  ],
                ),
              ],
            )
          )
  ]

      )
      ),
      onTap: (){

      },
    );
  }
}
