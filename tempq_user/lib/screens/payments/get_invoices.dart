import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tempq_user/screens/payments/view_pdf.dart';
import '../../components/defaultAppBar.dart';
import '../../models/userModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/format_date.dart';

class PdfData {
  final String userId;
  final String invoiceId;
  final String fileUrl;
  final String timeStamp;

  PdfData({required this.userId, required this.invoiceId, required this.fileUrl,
  required this.timeStamp});

  factory PdfData.fromJson(Map<String, dynamic> json) {
    return PdfData(
      userId: json['user_id'],
      invoiceId: json['inv_id'],
      fileUrl: json['invoice_pdf'],
      timeStamp: json['generated_on'].toString(),
    );
  }
}

class PdfListScreen extends StatefulWidget {
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<PdfData> pdfList = [];
  UserModel user = UserModel.myUser;

  @override
  void initState() {
    super.initState();
    fetchPdfData();
  }

  Future<void> fetchPdfData() async {
    const url = 'http://tempq.frostcarusa.com/tempQ/invoices/retreive_pdf.php'; // Replace with your API endpoint
    // final response = await http.post(Uri.parse(url));
    var response = await http.post(Uri.parse(url), headers: {"Accept": "application/json"},
        body: {
          "user_id": user.userId.toString()
        });

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        pdfList = jsonData.map((item) => PdfData.fromJson(item)).toList();
      });
    } else {
      print('Failed to fetch PDF data.');
    }
  }

  Future<void> openFile(String filepath) async {
    String filepath1  = "http://tempq.frostcarusa.com/tempQ/invoices/$filepath";
    print(filepath1);
    final Uri url = Uri.parse(filepath1);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:defaultAppBar(context, "My Invoices"),
      body: ListView.builder(
        itemCount: pdfList.length,
        itemBuilder: (context, index) {
          PdfData pdfData = pdfList[index];
          return
            Padding(
              padding: const EdgeInsets.only(top:8.0, left:8.0, right: 8.0),
              child: Card(
              child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red,),
                title: Text(pdfData.invoiceId),
                subtitle: Text(FormatDate.formatDateTime(pdfData.timeStamp.toString())),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        PdfViewerPage(url:"http://tempq.frostcarusa.com/tempQ/invoices/${pdfData.fileUrl}",invoiceNumber: pdfData.invoiceId),
                    ),
                  );
                  // openFile(pdfData.fileUrl);
                },
              ),
          ),
            );
        },
      ),
    );
  }


}
