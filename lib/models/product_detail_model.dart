class ProductDetailsModel {
  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.type,
    required this.isActive,
    required this.admin,
    required this.createdAt,
    required this.updatedAt,
    required this.V,
  });
  late final String id;
  late final String name;
  late final int price;
  late final String image;
  late final String type;
  late final bool isActive;
  late final String admin;
  late final String createdAt;
  late final String updatedAt;
  late final int V;

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    type = json['type'];
    isActive = json['isActive'];
    admin = json['admin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['image'] = image;
    _data['type'] = type;
    _data['isActive'] = isActive;
    _data['admin'] = admin;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['__v'] = V;
    return _data;
  }
}
