import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/paymentPlanModel.dart';

class PaymentPlanCardInfo extends StatelessWidget {
  const PaymentPlanCardInfo({
    Key? key,
    required this.info,
  }) : super(key: key);

  final PaymentInfo info;



  @override
  Widget build(BuildContext context) {
    String payment;
    if(info.charges==10){
      payment="month";
    }else{
      payment="year";
    }
    return
      Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                  info.iconSrc!,
                  color: info.color,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          Text(
            '${info.charges.toString()} \$ per ${payment}' ,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: blackColor,
                fontSize: subHeadingFontSize,
              fontWeight: FontWeight.bold
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'For 1 sensor',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: greyColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

