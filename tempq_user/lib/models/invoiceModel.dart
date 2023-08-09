class InvoiceModel {
  late String counter;
  late String invId;
  late String dateOfIssue;
  late String userId;
  late String issueBy;
  late String dueDate;
  late String? planId;
  late String total;
  late String discount;
  late String? approvedBy;
  late String validTill;
  late String totalQty;
  late String planType;
  late String invDetailsId;
  late String deviceId;
  late String qty;
  late String unitPrice;
  late String userFullName;
  late String userEmail;
  late String userContact;
  late String? userLocation;
  late String userCreatedOn;
  late String? userAge;
  late String? userGender;
  late String userCompany;
  late String? userImage;
  late String userType;

  InvoiceModel({
    required this.counter,
    required this.invId,
    required this.dateOfIssue,
    required this.userId,
    required this.issueBy,
    required this.dueDate,
    required this.planId,
    required this.total,
    required this.discount,
    required this.approvedBy,
    required this.validTill,
    required this.totalQty,
    required this.planType,
    required this.invDetailsId,
    required this.deviceId,
    required this.qty,
    required this.unitPrice,
    required this.userFullName,
    required this.userEmail,
    required this.userContact,
    required this.userLocation,
    required this.userCreatedOn,
    required this.userAge,
    required this.userGender,
    required this.userCompany,
    required this.userImage,
    required this.userType,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      counter: json['counter'],
      invId: json['inv_id'],
      dateOfIssue: json['date_of_issue'],
      userId: json['user_id'],
      issueBy: json['issue_by'],
      dueDate: json['due_date'],
      planId: json['plan_id'],
      total: json['total'],
      discount: json['discount'],
      approvedBy: json['approved_by'],
      validTill: json['valid_till'],
      totalQty: json['total_qty'],
      planType: json['plan_type'],
      invDetailsId: json['inv_details_id'],
      deviceId: json['device_id'],
      qty: json['qty'],
      unitPrice: json['unit_price'],
      userFullName: json['user_full_name'],
      userEmail: json['user_email'],
      userContact: json['user_contact'],
      userLocation: json['user_location'],
      userCreatedOn: json['user_created_on'],
      userAge: json['user_age'],
      userGender: json['user_gender'],
      userCompany: json['user_company'],
      userImage: json['user_image'],
      userType: json['user_type'],
    );
  }
}
