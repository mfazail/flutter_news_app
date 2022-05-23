class PageModel {
  final String content;

  PageModel({required this.content});

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      content: json['content']['rendered'] as String,
    );
  }
}
