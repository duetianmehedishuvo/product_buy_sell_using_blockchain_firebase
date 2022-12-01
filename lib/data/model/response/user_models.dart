class UserModels {
  UserModels({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.role,
    this.outletName,
    this.updatedAt,
    this.createdAt,
    this.adminApproval,
    this.isAdmin,
  });

  UserModels.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    role = json['role'];
    outletName = json['outletName'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    adminApproval = json['adminApproval'];
    isAdmin = json['isAdmin'];
  }

  num? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  num? role;
  String? outletName;
  String? updatedAt;
  String? createdAt;
  num? adminApproval;
  num? isAdmin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phone'] = phone;
    map['password'] = password;
    map['role'] = role;
    map['outletName'] = outletName;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['adminApproval'] = adminApproval;
    map['isAdmin'] = isAdmin;
    return map;
  }
}
