class ImageUploadModel {
  ImageUploadModel({
    required this.name,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.V,
  });
  late final String name;
  late final String id;
  late final String createdAt;
  late final String updatedAt;
  late final int V;

  ImageUploadModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['_id'] = id;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['__v'] = V;
    return _data;
  }
}
