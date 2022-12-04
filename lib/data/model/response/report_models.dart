class ReportModels {
  ReportModels({
    this.reportID,
    this.productID,
    this.description,
    this.status,
  });

  ReportModels.fromJson(dynamic json) {
    reportID = json['reportID'];
    productID = json['productID'];
    description = json['description'];
    status = json['status'];
  }

  String? reportID;
  String? productID;
  String? description;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reportID'] = reportID;
    map['productID'] = productID;
    map['description'] = description;
    map['status'] = status;
    return map;
  }
}
