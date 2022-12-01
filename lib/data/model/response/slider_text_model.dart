class SliderTextModel {
  SliderTextModel({
      this.id, 
      this.text,});

  SliderTextModel.fromJson(dynamic json) {
    id = json['id'];
    text = json['text'];
  }
  num? id;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    return map;
  }

}