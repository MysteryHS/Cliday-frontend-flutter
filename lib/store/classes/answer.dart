class Answer {
  DateTime date = DateTime.now();
  String category = "";
  bool isCorrect = false;
  int questionId = -1;
  int id = -1;

  Answer(this.date, this.isCorrect, this.questionId, this.id, this.category);

  String toString() {
    return date.toString() +
        " " +
        isCorrect.toString() +
        " " +
        questionId.toString();
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      DateTime.parse(json['date']!),
      json['is_correct'],
      json['question'],
      json['id'],
      json['category'],
    );
  }
}
