class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final String content;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.content,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      content: json['content'] ?? 'Full article content is unavailable.',
      publishedAt: DateTime.parse(json['publishedAt']
          ?? DateTime.now().toIso8601String()),
    );
  }
}
