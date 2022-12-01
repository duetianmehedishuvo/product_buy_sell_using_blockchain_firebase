class Users {
  final String phone;
  final String name;
  final String address;
  final String password;
  final int userType;

  Users(this.phone, this.name, this.address, this.password, this.userType);

  Users.fromJson(Map<String, dynamic> json)
      : phone = json['user_phone'],
        name = json['user_name'],
        password = json['user_password'],
        userType = json['user_type'],
        address = json['user_address'];

  Map<String, dynamic> toJson() =>
      {'user_phone': phone, 'user_name': name, 'user_password': password, 'user_type': userType, 'user_address': address};
}
