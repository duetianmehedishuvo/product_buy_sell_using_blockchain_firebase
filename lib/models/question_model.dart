class QuestionModel {
  final String questionID;
  final String title;
  final String sortDescription;


  QuestionModel(this.questionID, this.title, this.sortDescription);

  QuestionModel.fromJson(Map<String, dynamic> json)
      : questionID = json['questionID'],
        sortDescription = json['sortDescription'],
        title = json['title'];

  Map<String, dynamic> toJson() => {'questionID': questionID, 'title': title, 'sortDescription': sortDescription};
}
