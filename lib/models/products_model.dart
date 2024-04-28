class ProductsModel {
  ProductsModel({
    required this.products,
    required this.total,
  });

  final List<Product> products;
  final int? total;

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      products: json["products"] == null
          ? []
          : List<Product>.from(
              json["products"]!.map((x) => Product.fromJson(x))),
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "products": products.map((x) => x.toJson()).toList(),
        "total": total,
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.type,
    required this.isActive,
    required this.admin,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? name;
  final int? price;
  final String? image;
  final String? type;
  final bool? isActive;
  final Admin? admin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      name: json["name"],
      price: json["price"],
      image: json["image"],
      type: json["type"],
      isActive: json["isActive"],
      admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "image": image,
        "type": type,
        "isActive": isActive,
        "admin": admin?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };

  copyWith(
      {required String name,
      required String price,
      required String image,
      required String type}) {}
}

class Admin {
  Admin({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final String? id;
  final String? firstName;
  final String? lastName;

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
      };
}
