class LogInModel {
  LogInModel({
    required this.admin,
    required this.token,
  });
  late final Admin admin;
  late final String token;

  LogInModel.fromJson(Map<String, dynamic> json) {
    admin = Admin.fromJson(json['admin']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['admin'] = admin.toJson();
    _data['token'] = token;
    return _data;
  }
}

class Admin {
  Admin({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.password,
    required this.V,
    required this.isActive,
  });
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String phoneNumber;
  late final String role;
  late final String password;
  late final int V;
  late final bool isActive;

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    password = json['password'];
    V = json['__v'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['email'] = email;
    _data['phoneNumber'] = phoneNumber;
    _data['role'] = role;
    _data['password'] = password;
    _data['__v'] = V;
    _data['isActive'] = isActive;
    return _data;
  }
}
