class Post {
  final int id;
  final String date;
  final String title;
  final String content;
  final List<dynamic> categories;
  final String imageUrl;
  final String link;
  Post({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.categories,
    required this.imageUrl,
    required this.link,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      date: json['date'] as String,
      title: json['title']['rendered'] as String,
      content: json['content']['rendered'] as String,
      categories: json['categories'] as List<dynamic>,
      imageUrl: json['jetpack_featured_media_url'] as String,
      link: json['link'] as String,
    );
  }
}
