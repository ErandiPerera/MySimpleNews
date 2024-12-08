import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/news_provider.dart';
import 'category_screen.dart';
import 'favorite_news_screen.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<String> categories = [
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];


  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetSearch() {
    _searchController.clear();
    Provider.of<NewsProvider>(context, listen: false).fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 100.0,
        title: Text('My Simple News',
            style: TextStyle(color: Colors.white),
      ),
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
                    "View Favorites",
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
      padding: EdgeInsets.all(8.20),
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
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: SizedBox(
            height: 50,
            child: ListView.builder(scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          category: categories[index],),
                      ),
                    ).then((_) {
                      _resetSearch();
                    });},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(categories[index].toUpperCase(),
                        style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                if (newsProvider.articles.isEmpty) {
                  return Center(child: Text('No news found.'));
                } else {
                  return ListView.builder(
                    itemCount: newsProvider.articles.length,
                    itemBuilder: (context, index) {
                      NewsArticle article = newsProvider.articles[index];
                      return Card(
                        color: Colors.white70,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(article:
                                article),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (article.urlToImage.isNotEmpty)
                                Image.network(article.urlToImage,
                                  width: double.infinity,
                                  height: 150, fit: BoxFit.cover,)
                              else
                                Container(
                                  height: 150, width: double.infinity,
                                  color: Colors.grey,
                                  child: Center
                                    (child: Text('No Image Available')),),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(article.title,
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold),),
                                    SizedBox(height: 8),
                                    Text(article.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14,
                                          color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),

                              Align(
                                alignment: Alignment.center,
                                child: Consumer<NewsProvider>(
                                  builder: (context, newsProvider, child) {
                                    final isFav = newsProvider.isFavorite(article);
                                    return IconButton(
                                      icon: Icon(
                                        isFav ? Icons.favorite :
                                        Icons.favorite_border,
                                        color: isFav ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () {
                                        if (isFav) {
                                          newsProvider.removeFromFavorites(article);

                                        } else {
                                          newsProvider.addToFavorites(article);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Added to Favorites!",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
