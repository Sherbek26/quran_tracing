enum Types { special, usual }

// const typeIcons = {
//   Types.special: Icons.lunch_dining,
//   Types.usual: Icons.flight_takeoff,
// };

class CreatedProduct {
  CreatedProduct({
    required this.name,
    required this.price,
    required this.image,
    required this.type,
    required this.isActive,
    required this.admin,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? name;
  final int? price;
  final String? image;
  final String? type;
  final bool? isActive;
  final String? admin;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory CreatedProduct.fromJson(Map<String, dynamic> json) {
    return CreatedProduct(
      name: json["name"],
      price: json["price"],
      image: json["image"],
      type: json["type"],
      isActive: json["isActive"],
      admin: json["admin"],
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "image": image,
        "type": type,
        "isActive": isActive,
        "admin": admin,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
