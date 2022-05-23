class Comments {
  final int id;
  final String authorName;
  final String date;
  final String content;
  final String status;

  Comments(
      {required this.id,
      required this.authorName,
      required this.date,
      required this.content,
      required this.status});

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'] as int,
      authorName: json['author_name'] as String,
      date: json['date'] as String,
      content: json['content']['rendered'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author_name'] = this.authorName;
    data['date'] = this.date;
    data['content']['rendered'] = this.content;
    data['status'] = this.status;
    return data;
  }
}
