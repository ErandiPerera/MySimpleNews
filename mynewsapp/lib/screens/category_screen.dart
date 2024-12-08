import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/news_provider.dart';
import 'favorite_news_screen.dart';
import 'news_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.toUpperCase(),
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  "Favorites",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                Provider.of<NewsProvider>(context, listen: false)
                    .searchArticles(value);
              },
              decoration: InputDecoration(
                hintText: 'Search news by title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<NewsProvider>(context, listen: false)
                  .fetchNews(category: widget.category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading news'));
                } else {
                  return Consumer<NewsProvider>(
                    builder: (context, newsProvider, child) {
                      final articles = newsProvider.articles;
                      if (articles.isEmpty) {
                        return Center(child: Text('No news found.'));
                      }
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          NewsArticle article = articles[index];
                          return Card(
                            margin: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) =>
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
                                        final isFav = newsProvider
                                            .isFavorite(article);
                                        return IconButton(
                                          icon: Icon(
                                            isFav
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFav
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            if (isFav) {
                                              newsProvider
                                                  .removeFromFavorites(
                                                  article);
                                            } else {
                                              newsProvider.addToFavorites(
                                                  article);
                                            }
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
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
