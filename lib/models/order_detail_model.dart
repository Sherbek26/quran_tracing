class OrderDetailModel {
  OrderDetailModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.status,
    required this.comment,
    required this.user,
    required this.shippingInfo,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final List<ProductElement> products;
  final int? totalPrice;
  final String? status;
  final String? comment;
  final User? user;
  final ShippingInfo? shippingInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json["_id"],
      products: json["products"] == null
          ? []
          : List<ProductElement>.from(
              json["products"]!.map((x) => ProductElement.fromJson(x))),
      totalPrice: json["totalPrice"],
      status: json["status"],
      comment: json["comment"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      shippingInfo: json["shippingInfo"] == null
          ? null
          : ShippingInfo.fromJson(json["shippingInfo"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "products": products.map((x) => x.toJson()).toList(),
        "totalPrice": totalPrice,
        "status": status,
        "comment": comment,
        "user": user?.toJson(),
        "shippingInfo": shippingInfo?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class ProductElement {
  ProductElement({
    required this.product,
    required this.quantity,
    required this.id,
  });

  final ProductProduct? product;
  final int? quantity;
  final String? id;

  factory ProductElement.fromJson(Map<String, dynamic> json) {
    return ProductElement(
      product: json["product"] == null
          ? null
          : ProductProduct.fromJson(json["product"]),
      quantity: json["quantity"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "product": product?.toJson(),
        "quantity": quantity,
        "_id": id,
      };
}

class ProductProduct {
  ProductProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.isActive,
    required this.admin,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.type,
  });

  final String? id;
  final String? name;
  final int? price;
  final String? image;
  final bool? isActive;
  final String? admin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? type;

  factory ProductProduct.fromJson(Map<String, dynamic> json) {
    return ProductProduct(
      id: json["_id"],
      name: json["name"],
      price: json["price"],
      image: json["image"],
      isActive: json["isActive"],
      admin: json["admin"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "image": image,
        "isActive": isActive,
        "admin": admin,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "type": type,
      };
}

class ShippingInfo {
  ShippingInfo({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.region,
    required this.district,
    required this.address,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? region;
  final String? district;
  final String? address;
  final String? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory ShippingInfo.fromJson(Map<String, dynamic> json) {
    return ShippingInfo(
      id: json["_id"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      region: json["region"],
      district: json["district"],
      address: json["address"],
      user: json["user"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "region": region,
        "district": district,
        "address": address,
        "user": user,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class User {
  User({
    required this.id,
    required this.userId,
    required this.tgFirstName,
    required this.tgLastName,
    required this.username,
    required this.role,
    required this.step,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? userId;
  final String? tgFirstName;
  final String? tgLastName;
  final String? username;
  final String? role;
  final String? step;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      userId: json["userId"],
      tgFirstName: json["tgFirstName"],
      tgLastName: json["tgLastName"],
      username: json["username"],
      role: json["role"],
      step: json["step"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "tgFirstName": tgFirstName,
        "tgLastName": tgLastName,
        "username": username,
        "role": role,
        "step": step,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
