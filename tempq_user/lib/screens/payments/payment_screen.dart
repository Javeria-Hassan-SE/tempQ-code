import 'dart:convert';
import 'package:flutter/material.dart' hide MenuController;
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/pdf_api.dart';
import '../../../api/pdf_invoice_api.dart';
import '../../../network/GetNetworkCalls.dart';
import '../../components/button_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../controller/menu_controller.dart';
import '../../models/customer.dart';
import '../../models/generateInvoiceModel.dart';
import '../../models/invoice.dart';
import '../../models/supplier.dart';
import '../../models/userModel.dart';
import '../main/main_screen.dart';
import 'package:intl/intl.dart';

import '../notifications/send_notification.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<String> id = [];
  var user = UserModel.myUser;
  String location = '';
  int paymentAmount = 0;

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
  GetNetworkCalls networkCall = GetNetworkCalls();
  DateTime now = DateTime.now();

  /// Initialize Network call Class
  int selectedPaymentPlan = 0;

  /// Remember user choice
  /// boolean variables to check which plan has been choose by user to change the card color accordingly
  bool isPlan1Selected = false;
  bool isPlan2Selected = false;
  bool enable = true;
  SendUserNotification notify = SendUserNotification();

  /// Init State
  @override
  void initState() {
    super.initState();
    if (user.userLocation == null) {
      location = 'Not Defined';
    } else {
      location = user.userLocation!;
    }
    getNetworkCalls();
    if (devicesToBePaid.isEmpty) {
      devicesToBePaid.add("You have currently no unpaid device");
      enable = false;
    }
  }

  /// Get Unpaid Devices List
  getNetworkCalls() async {
    await networkCall.getUserDevicesData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: defaultAppBar(context, "New Subscription"),
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Text(
                  "Choose Your Plan",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: subHeadingFontSize),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: isPlan1Selected
                              ? primaryColor.withOpacity(0.5)
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
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
                              style: TextStyle(
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
                      onTap: () {
                        setState(() {
                          isPlan1Selected = true;
                          isPlan2Selected = false;
                          selectedPaymentPlan = 1;
                        });
                      }),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: isPlan2Selected
                            ? primaryColor.withOpacity(0.5)
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                            style: TextStyle(
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
                    onTap: () {
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
                items: devicesToBePaid,
                onSelect: (value) {
                  if (mounted) {
                    setState(() {
                      selectedIndex = value;
                      if (selectedIndex.isNotEmpty) {
                        selectedDevice = true;
                        quantity++;
                      } else {
                        selectedDevice = false;
                      }
                    });
                  }
                },
                dropdownTitleTileText: 'Select Device',
                dropdownTitleTileMargin: const EdgeInsets.only(
                    top: 5, left: 16, right: 16, bottom: 5),
                dropdownTitleTilePadding: const EdgeInsets.all(10),
                dropdownUnderlineBorder:
                    const BorderSide(color: Colors.transparent, width: 2),
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
                buttonColor: primaryColor,
                dropdownTitleTileTextStyle:
                    const TextStyle(fontSize: 14, color: Colors.black54),
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.all(6),
                type: GFCheckboxType.basic,
                inactiveBorderColor: Colors.grey.shade300,
              ),
              const SizedBox(height: defaultPadding),
              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ButtonWidget(
                  text: 'Create Invoice',
                  onClicked: () async {
                    if (enable) {
                      checkPlan();
                      if (selectedDevice != false &&
                          payment != 0 &&
                          (isPlan1Selected != false ||
                              isPlan2Selected != false)) {
                        setState(() {
                          loading = true;
                        });
                        await generateInvoice();
                        setState(() {
                          loading = false;
                        });
                      } else {
                        showMessage('Invalid data', Colors.red);
                      }
                    } else {
                      showMessage(
                          'You currently have no device to buy subscription',
                          Colors.red);
                    }
                  },
                  size: size,
                ),
              ),
              !loading
                  ? const Text("")
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
            ],
          ),
        ));
  }

  Future<void> generateInvoice() async {
    /// Set Invoice ID
    var invoiceId = await networkCall.getInvoiceNumber();
    invoiceId = int.parse(invoiceId);
    invoiceId++;
    invoiceNumber = 'INV${invoiceId.toString().padLeft(3, '0')}';

    /// Set due Date
    dueDate = date.add(const Duration(days: 7));

    /// Set Payment Terms
    String paymentTerm = "";
    if (planType == "Monthly") {
      valid_date = date.add(const Duration(days: 30));
      paymentTerm = '30 days';
    } else if (planType == "Yearly") {
      valid_date = date.add(const Duration(days: 365));
      paymentTerm = '1 Year';
    }

    /// Set total price according to quantity
    int count = 0;
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
    total_price = count * unit_price;

    /// Create Invoice Supplier and Customer Info
    final invoice = Invoice(
        supplier: const Supplier(
          name: 'Temp Q',
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
          invoiceNumber: invoiceNumber,
          paymentTerms: paymentTerm,
        ),
        device_id: device_id);
    text = "";
    selectedIndex = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("invoice", "");
    isInvoiceGenerated = 1;
    var msg = await uploadInvoiceInfo();
    if (msg == "Success") {
      /// Generate PDF Voucher
      final pdfFile = await PdfInvoiceApi.generate(invoice);
      /// Open PDF Voucher
      PdfApi.openFile(pdfFile);
      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      PdfApi.uploadFile(file: pdfFile, userId: user.userId.toString(), invoiceId: invoiceNumber, timeStamp: formattedDateTime)
          .then((_) {
        // Handle the success case, if needed
        sendNotification(invoiceNumber);
      }).catchError((error) {
        // Handle the error case, if needed
        print('not uploaded');
      });
    } else {
      navigateToDashboard();
    }
  }
  sendNotification(String invId){
    notify.sendNotification(
        subject: "New Subscription Added - Temp Q Application",
        emailMessage:
        "Dear User, You have buy the $planType subscription for $quantity sensors."
            "Kindly pay the voucher before expiry date, Your invoice number is $invId.",
        messageType: "Subscription Buy",
        messageTitle: "New Subscription Added",
        message:
        "Dear User, You have buy the $planType subscription for $quantity sensors."
            "Kindly pay the voucher before expiry date, Your invoice number is $invId.");

    /// Send Notification to Admin
    notify.sendNotificationToAdmin(
        subject: "Alert: New Subscription Added - Temp Q Application",
        emailMessage:
        "The User ${user.userEmail} has buy the $planType subscription for $quantity sensors"
            "Kindly, check the voucher and enable the device accordingly.",
        messageType: "New Subscription Added",
        messageTitle: "New Subscription Buy by User ${user.userEmail}",
        message:
        "The User ${user.userEmail} has buy the $planType subscription for $quantity sensors"
            "Kindly, check the voucher and enable the device accordingly.");

  }

  void navigateToDashboard(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => MenuController(),
              ),
            ],
            child:  MainScreen(),
          ),
        ));
  }

  /// Upload Invoice Info to database

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
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/invoices/save_invoice_info_to_database.php');
    String jsonData = json.encode(data);
    var response = await http.post(url,
        headers: {"Accept": "application/json"}, body: jsonData);
    var msg = json.decode(response.body);
    return msg;
  }

  /// Select Payment
  void setPayment(int payment) {
    this.payment = payment;
  }

  /// Set user selected values
  void setValues() {
    quantity = selectedIndex.length;
    for (var i = 0; i < selectedIndex.length; i++) {
      id.add(devicesToBePaid[selectedIndex[i]]);
    }
    for (var x in id) {
      concatenate.write("$x\n");
    }
  }

  /// Show Message
  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: TextStyle(fontSize: 16, color: color),
    )));
  }

  /// Check which plan user has select, and set the amount accordingly
  void checkPlan() {
    if (mounted) {
      setState(() {
        setValues();
        if (quantity <= 0) {
          showMessage("Please select device first", Colors.red);
        } else if (selectedPaymentPlan == 0) {
          showMessage("Please Choose your plan first", Colors.red);
        } else {
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
}
