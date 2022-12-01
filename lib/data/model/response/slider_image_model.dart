class SliderImageModel {
  SliderImageModel({
    this.id,
    this.imageUrl,
  });

  SliderImageModel.fromJson(dynamic json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
  }

  num? id;
  String? imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['imageUrl'] = imageUrl;
    return map;
  }
}
