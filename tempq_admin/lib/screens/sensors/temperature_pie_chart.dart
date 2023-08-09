
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
    var tempRange2= widget.tempValue;
    var temp = widget.tempValue.toString();
    double tempValue = 20;
    double tempRange = 40;
    return InkWell(
      child:
      Container(
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
                  axisLabelStyle: GaugeTextStyle(fontSize:8),
                  minimum: -tempRange,
                  maximum: tempRange+0.1,
                  startAngle: 180,
                  endAngle: 0,
                  canScaleToFit: true,
                  interval: 10,
                  majorTickStyle: MajorTickStyle(length: 0.1, thickness: 0.1, lengthUnit: GaugeSizeUnit.factor,
                  ),
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: -tempRange, endValue: tempRange, color: Colors.blue, startWidth: 10, endWidth: 10),

                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(value: tempRange2, needleEndWidth: 5, animationDuration: 1000),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        child: Text('$temp °F', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      angle: 90,
                      positionFactor: 0.4,
                    ),
                  ],
                ),
              ],
            )
            // SfRadialGauge(
            //     axes: <RadialAxis>[
            //       RadialAxis(minimum: -360,maximum: 360,
            //           //radiusFactor: 0.8,
            //           startAngle: 180,
            //           endAngle: 0,
            //        // canScaleToFit: false,
            //           canScaleToFit: true,
            //           ranges: <GaugeRange>[
            //             GaugeRange(startValue: -360,endValue: -180,color: Colors.blue,startWidth: 10,endWidth: 10),
            //             GaugeRange(startValue: -180,endValue: 0,color: Colors.green,startWidth: 10,endWidth: 10),
            //             GaugeRange(startValue: 0,endValue: 180,color: Colors.red,startWidth: 10,endWidth: 10),
            //             GaugeRange(startValue: 180,endValue: 360,color: Colors.yellow,startWidth: 10,endWidth: 10)],
            //           pointers: <GaugePointer>[NeedlePointer(value:widget.tempValue,
            //           needleEndWidth: 5,
            //           animationDuration: 1000,)],
            //           annotations: <GaugeAnnotation>[
            //             GaugeAnnotation(widget: Container(child:
            //             Text(temp,style: TextStyle(fontSize:16,fontWeight:FontWeight.bold))),
            //                 angle: 90,positionFactor: 0.3)]
            //       )]
            // ),
          )
  ]

      )
      ),
      onTap: (){
       // Navigator.push(context, MaterialPageRoute(builder: (context) =>  CurrentDeviceHistory()));
      },
    );
  }
}
