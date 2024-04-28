class UsersModel {
  UsersModel({
    required this.users,
    required this.total,
  });

  final List<User> users;
  final int? total;

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      users: json["users"] == null
          ? []
          : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "users": users.map((x) => x.toJson()).toList(),
        "total": total,
      };
}

class User {
  User({
    required this.id,
    required this.userId,
    required this.tgFirstName,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.username,
  });

  final String? id;
  final String? userId;
  final String? tgFirstName;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? username;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      userId: json["userId"],
      tgFirstName: json["tgFirstName"],
      role: json["role"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "tgFirstName": tgFirstName,
        "role": role,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "username": username,
      };
}
