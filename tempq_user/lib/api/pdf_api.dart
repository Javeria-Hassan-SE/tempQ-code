import 'dart:convert';
import 'dart:io';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:http/http.dart' as http;

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Future<String> uploadFile({
    required File file,
    required String userId,
    required String invoiceId, required String timeStamp,
  }) async {
    const url = 'http://tempq.frostcarusa.com/tempQ/invoices/upload_pdf.php';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = userId;
    request.fields['invoice_id'] = invoiceId;
    request.fields['generated_on']=timeStamp;
    request.files.add(
      await http.MultipartFile.fromPath('pdf_file', file.path),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return "Error";
    }
  }


}
