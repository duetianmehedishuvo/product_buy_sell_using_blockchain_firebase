class ReferenceModel {
  final String referenceId;
  final String title;

  ReferenceModel(this.referenceId, this.title);

  ReferenceModel.fromJson(Map<String, dynamic> json)
      : referenceId = json['reference_Id'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
    'reference_Id': referenceId,
    'title': title
  };
}