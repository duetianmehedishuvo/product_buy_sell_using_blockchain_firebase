class ReportModels {
  ReportModels({
    this.reportID,
    this.productID,
    this.description,
    this.userID,
    this.status,
  });

  ReportModels.fromJson(dynamic json) {
    reportID = json['reportID'];
    productID = json['productID'];
    description = json['description'];
    userID = json['userID'];
    status = json['status'];
  }

  String? reportID;
  String? productID;
  String? userID;
  String? description;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reportID'] = reportID;
    map['productID'] = productID;
    map['userID'] = userID;
    map['description'] = description;
    map['status'] = status;
    return map;
  }
}
