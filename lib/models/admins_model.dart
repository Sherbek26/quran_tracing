class AdminsModel {
  AdminsModel({
    required this.admins,
    required this.total,
  });

  final List<Admin> admins;
  final int? total;

  factory AdminsModel.fromJson(Map<String, dynamic> json) {
    return AdminsModel(
      admins: json["admins"] == null
          ? []
          : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "admins": admins.map((x) => x.toJson()).toList(),
        "total": total,
      };
}

class Admin {
  Admin({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.v,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final bool? isActive;
  final int? v;

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      role: json["role"],
      isActive: json["isActive"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "role": role,
        "isActive": isActive,
        "__v": v,
      };
}
