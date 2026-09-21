class Subject {
  final String id;
  final String text;

  Subject({required this.id, required this.text});

  Subject copyWith({String? id, String? text}) {
    return Subject(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
      };

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String? ??
          '${DateTime.now().microsecondsSinceEpoch}_${json['text']}',
      text: json['text'] as String? ?? '',
    );
  }
}
