import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../models/article.dart';
import 'news_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {


  void _showRemoveDialog(
      BuildContext context, NewsArticle article, NewsProvider newsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Favorite'),
        content: Text('Are you Really want to remove this article from '
            'favorites?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              newsProvider.removeFromFavorites(article);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text("Article removed from favorites!"),
                  duration: Duration(seconds: 2),),);
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Articles',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.favorites.isEmpty) {
            return Center(child: Text('No favorites added.'));
          } else {
            return ListView.builder(
              itemCount: newsProvider.favorites.length,
              itemBuilder: (context, index) {
                NewsArticle article = newsProvider.favorites[index];
                return Card(color: Colors.white70,
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                              NewsDetailScreen(article: article),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.urlToImage.isNotEmpty)
                          Image.network(
                            article.urlToImage,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        else
                          Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Center(
                                child: Text('No Image Available')),
                          ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                article.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Consumer<NewsProvider>(
                            builder: (context, newsProvider, child) {
                              return IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showRemoveDialog(context, article,
                                      newsProvider);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
