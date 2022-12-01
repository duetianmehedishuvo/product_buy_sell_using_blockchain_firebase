class UserModels {
  UserModels({
    this.name,
    this.phone,
    this.password,
    this.userType,
    this.address,
  });

  UserModels.fromJson(dynamic json) {
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    userType = json['userType'];
    address = json['address'];
  }

  String? name;
  String? phone;
  String? password;
  int? userType;
  String? address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['phone'] = phone;
    map['password'] = password;
    map['userType'] = userType;
    map['address'] = address;
    return map;
  }
}
