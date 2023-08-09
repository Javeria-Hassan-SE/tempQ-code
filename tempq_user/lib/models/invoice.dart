



import 'package:tempq_user/models/supplier.dart';

import 'customer.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> device_id;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.device_id,

  });

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      // 'supplier': supplier.toJson(),
      // 'customer': customer.toJson(),
      'device_id': device_id.map((item) => item.toJson()).toList(),
    };
  }
}

class InvoiceInfo {
  final String invoiceNumber;
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;
  final String paymentTerms;

  const InvoiceInfo( {
    required this.invoiceNumber,
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
    required this.paymentTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'inv_id': invoiceNumber,
      'description': description,
      'number': number,
      'date_of_issue': date.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
    };
  }
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'date': date.toIso8601String(),
      'quantity': quantity,
      'vat': vat,
      'unitPrice': unitPrice
    };
  }
  // factory Invoice.fromJson(Map<String, dynamic> json) {
  //   return Invoice(
  //       info: json['user_device_id'],
  //       deviceName: json['device_name'],
  //       deviceId: json['device_id'],
  //       deviceCat: json['device_cat'],
  //       securityCode: json['security_code'],
  //       userId: int.parse(json['user_id']),
  //       isPaid: json['is_paid'],
  //       status: json['status'],
  //       addedOn: DateTime.parse(json['added_on']));
  // }
  //
  // Map<String, dynamic> toJson() => {
  //   'user_device_id':userDeviceID,
  //   'device_name':deviceName,
  //   'device_id': deviceId,
  //   'device_cat': deviceCat,
  //   'addedOn': addedOn,
  //   'user_id':userId,
  //   'security_code':securityCode,
  //   'is_paid':isPaid,
  //   'status': status
  // };
}
