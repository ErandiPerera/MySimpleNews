import 'package:flutter/material.dart';
import '../models/article.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  NewsDetailScreen({required this.article});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage.isNotEmpty)
              Image.network(
                article.urlToImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey,
                child: Center(child: Text("No Image Available")),
              ),
            SizedBox(height: 16),
            Text( article.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Published: ${article.publishedAt.toIso8601String()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(article.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Source: ${article.url}',
              style: TextStyle(fontSize: 16, color: Colors.cyan),
            ),
          ],
        ),
      ),
    );
  }
}
