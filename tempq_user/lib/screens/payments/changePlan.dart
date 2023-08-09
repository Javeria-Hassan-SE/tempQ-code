import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/pdf_api.dart';
import '../../../api/pdf_invoice_api.dart';
import '../../components/button_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/showScaffoldClass.dart';
import '../../constants/constants.dart';
import '../../models/customer.dart';
import '../../models/generateInvoiceModel.dart';
import '../../models/invoice.dart';
import '../../models/supplier.dart';
import '../../models/userModel.dart';
import '../../network/GetNetworkCalls.dart';
import 'package:intl/intl.dart';
import '../notifications/send_notification.dart';

class ChangePlanScreen extends StatefulWidget {
  final String deviceId;
  final String planType;
  const ChangePlanScreen({Key? key, required this.deviceId, required this.planType}) : super(key: key);

  @override
  State<ChangePlanScreen> createState() => _ChangePlanScreenState();
}

class _ChangePlanScreenState extends State<ChangePlanScreen> {
  List<String> id = [];
  List deviceId=[];
  var user = UserModel.myUser;
  String location = '';
  int paymentAmount = 0;
  int selectedPaymentPlan = 0;
  String errorMessage = "You don't have 6 sensor's to buy this subscription";
  bool selectedDevice = false;
  bool selectedPayment = false;
  var quantity = 0;
  String planType = "";
  var concatenate = StringBuffer();
  List selectedIndex = [];
  String text = "";
  bool loading = false;
  int payment = 0;
  var invoiceNumber;

  final date = DateTime.now();
  var dueDate, valid_date;
  final List<InvoiceItem> device_id = [];
  var plan_ID = 1;
  double total_price = 0;
  var networkCall= GetNetworkCalls();
  bool isPlan1Selected = false;
  bool isPlan2Selected = false;
  DateTime now = DateTime.now();
  SendUserNotification notify = SendUserNotification();

  @override
  void initState() {
    super.initState();
    deviceId.add(widget.deviceId);
    if (user.userLocation == null) {
      location = 'Not Defined';
    } else {
      location = user.userLocation!;
    }

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: defaultAppBar(context, "New Subscription"),
        body:
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding:const EdgeInsets.all(defaultPadding),
                child:  Text(
                  "Your current subscription is ${widget.planType}",
                  style:const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: subHeadingFontSize),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child:  Text(
                  "Change Your Plan",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: subHeadingFontSize),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.planType=='Yearly'
                   ? InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: isPlan1Selected ? primaryColor.withOpacity(0.5) : Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.yellow,
                            ),
                            const Text(
                              '10\$ Monthly',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                  color: blackColor,
                                  fontSize: subHeadingFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1 Sensor',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.black45),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          isPlan1Selected = true;
                          isPlan2Selected = false;
                          selectedPaymentPlan = 1;
                        });
                      }

                  )
                      : InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration:  BoxDecoration(
                        color: isPlan2Selected ? primaryColor.withOpacity(0.5) : Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.amberAccent,
                          ),
                          const Text(
                            '110 \$ Yearly',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(
                                color: blackColor,
                                fontSize: subHeadingFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1 Sensor',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.black45),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        isPlan1Selected = false;
                        isPlan2Selected = true;
                        selectedPaymentPlan = 2;
                      });

                    },
                  )
                ],
              ),
              const SizedBox(height: defaultPadding),
              const Text(
                "Select Your Device",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: subHeadingFontSize),
              ),
              const SizedBox(height: defaultPadding),
              GFMultiSelect(
                items: deviceId,
                onSelect: (value) {
                  setState(() {
                    selectedIndex = value;
                    if (selectedIndex.isNotEmpty) {
                      selectedDevice = true;
                      quantity++;
                    } else {
                      selectedDevice = false;
                    }
                  });
                },
                dropdownTitleTileText: 'Select Device',
                dropdownTitleTileMargin: const EdgeInsets.only(
                    top: 5, left: 16, right: 16, bottom: 5),
                dropdownTitleTilePadding: const EdgeInsets.all(10),
                dropdownUnderlineBorder: const BorderSide(
                    color: Colors.transparent, width: 2),
                dropdownTitleTileBorder:
                Border.all(color: Colors.grey, width: 1),
                dropdownTitleTileBorderRadius: BorderRadius.circular(5),
                expandedIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
                collapsedIcon: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.black54,
                ),
                submitButton: const Text('Select'),
                cancelButton: const Text('Cancel'),
                dropdownTitleTileTextStyle: const TextStyle(
                    fontSize: 14, color: Colors.black54),
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.all(6),
                type: GFCheckboxType.basic,
                activeBgColor: GFColors.SUCCESS,
                activeBorderColor: GFColors.SUCCESS,
                inactiveBorderColor: Colors.grey.shade300,
              ),
              const SizedBox(height: defaultPadding),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 10),
                child: ButtonWidget(
                  text: 'Create Invoice',
                  onClicked: () async {
                    checkPlan();
                    if (selectedDevice != false &&
                        payment != 0 && (isPlan1Selected !=false || isPlan2Selected !=false )) {
                      setState(() {
                        loading = true;
                      });
                      await generateInvoice();
                      setState(() {
                        loading = false;
                      });
                    } else {
                      showError(context);
                    }
                  }, size: size,
                ),
              ),
              !loading
                  ? const Text("")
                  : const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),)

            ],
          ),
        )
    );
  }
  void showError(context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Invalid Data',
          style: TextStyle(fontSize: 16, color: Colors.red),
        )));
  }



  Future<void> generateInvoice() async {
    var invoiceId = await networkCall.getInvoiceNumber();
    invoiceId = int.parse(invoiceId);
    invoiceId++;
    invoiceNumber = 'INV${invoiceId.toString().padLeft(3, '0')}';
    dueDate = date.add(const Duration(days: 7));
    String paymentTerm ="";
    if(planType=="Monthly"){
      valid_date = date.add(const Duration(days: 30));
      paymentTerm = '30 days';
    }else if(planType=="Yearly"){
      valid_date = date.add(const Duration(days: 365));
      paymentTerm = '1 Year';
    }

    int count=0;
    for (int i = 0; i < id.length; i++) {
      device_id.add(InvoiceItem(
        description: id[i],
        date: date,
        quantity: 1,
        vat: 0,
        unitPrice: unit_price,
      ));
      count++;
    }
    total_price=count*unit_price;


    final invoice = Invoice(
        supplier: const Supplier(
          name: 'tempQ',
          address: '73 High View Dr. Wingdale, NY 12594',
          paymentInfo: '1 914-327-9500',
        ),
        customer: Customer(
          name: user.userFullName,
          address: location,
        ),
        info: InvoiceInfo(
          date: date,
          dueDate: dueDate,
          description:
          'This invoice is generated for ${user.userFullName} for buying $quantity sensors from tecRoam.'
              'After payment, It is valid for $paymentTerm only',
          number: '${DateTime.now().year}-9999',
          invoiceNumber: invoiceNumber, paymentTerms: paymentTerm,

        ),
        device_id: device_id);
    text = "";
    selectedIndex = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("invoice", "");
    isInvoiceGenerated = 1;
    var response = await uploadInvoiceInfo();
    if (response == "Success") {
      var msg = await networkCall.changePlan(
          widget.deviceId, planType);
      if (msg == 'Success') {
        /// Generate PDF Voucher
        final pdfFile = await PdfInvoiceApi.generate(invoice);
        /// Open PDF Voucher
        PdfApi.openFile(pdfFile);
        String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        PdfApi.uploadFile(file: pdfFile, userId: user.userId.toString(), invoiceId: invoiceNumber, timeStamp: formattedDateTime)
            .then((_) {
          // Handle the success case, if needed
          sendNotification(invoiceNumber);
          showMessage('Subscription Changed Request has been send for approval', Colors.green);

        }).catchError((error) {
          // Handle the error case, if needed
          print('not uploaded');
        });
          }
      else if (msg == 'Error') {
        showMessage('Error Occurred', Colors.red);
      }

    } else {
      showMessage('Unable to generate invoice', Colors.red);
    }

  }

  /// Show Notification
  sendNotification(String invId){
    notify.sendNotification(
        subject: "Subscription Plan Changed - Temp Q Application",
        emailMessage:
        "Dear User, You have changed the subscription type for $deviceId to the $planType subscription."
            "Kindly pay the voucher before expiry date, Your invoice number is $invId.",
        messageType: "Subscription Plan Changed",
        messageTitle: "Subscription Plan Changed",
        message:
        "Dear User, You have changed the subscription type for $deviceId to the $planType subscription."
            "Kindly pay the voucher before expiry date, Your invoice number is $invId.");

    /// Send Notification to Admin
    notify.sendNotificationToAdmin(
        subject: "Subscription Plan Changed - Temp Q Application",
        emailMessage:
        "The User ${user.userEmail} has changed the subscription type for $deviceId to the $planType subscription."
            "Kindly, check the voucher and enable the device accordingly.",
        messageType: "Subscription Plan Changed",
        messageTitle: "Subscription Plan Changed by User ${user.userEmail}",
        message:
        "The User ${user.userEmail} has changed the subscription type for $deviceId to the $planType subscription."
            "Kindly, check the voucher and enable the device accordingly.");

  }


  /// Show Message
  showMessage(String message, Color color){
    ShowScaffoldClass().showScaffoldMessage(
        context, message, color);

  }
  Future uploadInvoiceInfo() async {
    var generateInvoice = GenerateInvoiceModel.myUser;
    generateInvoice.device_id = id;
    generateInvoice.unit_price = unit_price;
    generateInvoice.total = total_price;
    generateInvoice.user_id = user.userId;
    generateInvoice.date_of_issue = date;
    generateInvoice.inv_id = invoiceNumber;
    generateInvoice.discount = 0;
    generateInvoice.issue_by = 'System Generated';
    generateInvoice.qty = 1;
    generateInvoice.due_date = dueDate;
    generateInvoice.plan_id = plan_ID;

    Map<String, dynamic> data = {
      "inv_id": generateInvoice.inv_id,
      "date_of_issue": generateInvoice.date_of_issue.toIso8601String(),
      "user_id": generateInvoice.user_id,
      "issue_by": generateInvoice.issue_by,
      "due_date": generateInvoice.due_date.toIso8601String(),
      "plan_id": generateInvoice.plan_id,
      "total": generateInvoice.total,
      "discount": generateInvoice.discount,
      "device_id": generateInvoice.device_id,
      "valid_till": valid_date.toIso8601String(),
      "qty": generateInvoice.qty,
      "unit_price": generateInvoice.unit_price,
      "plan_type": planType
    };
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/invoices/save_invoice_info_to_database.php');
    String jsonData = json.encode(data);
    var response = await http.post(url,
        headers: {"Accept": "application/json"}, body: jsonData);
    var msg = json.decode(response.body);
    return msg;
  }

  void setPayment(int payment) {
    this.payment = payment;
  }

  void setValues() {
    quantity = selectedIndex.length;
    for (var i = 0; i < selectedIndex.length; i++) {
      id.add(deviceId[selectedIndex[i]]);
    }
    for (var x in id) {
      concatenate.write("$x\n");
    }
  }

  void checkPlan() {
    setState(() {
      setValues();
      if (quantity <= 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
            content: Text(
              "Please select device first",
              style: TextStyle(
                  fontSize: 16, color: Colors.red),
            )));
      } else if (selectedPaymentPlan == 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
            content: Text(
              "Please Choose your plan first",
              style: TextStyle(
                  fontSize: 16, color: Colors.red),
            )));
      }
      else {
        if (selectedPaymentPlan == 1) {
          paymentAmount = 10;
          unit_price = 10;
          planType = 'Monthly';
          setPayment(quantity * paymentAmount);
        } else if (selectedPaymentPlan == 2) {
          paymentAmount = 110;
          unit_price = 110;
          planType = 'Yearly';
          setPayment(quantity * paymentAmount);
        }
      }
    });
  }

}
