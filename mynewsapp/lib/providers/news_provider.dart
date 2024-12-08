import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/article.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _filteredArticles = [];
  List<NewsArticle> get articles => _filteredArticles;

  // Favorite articles list
  List<NewsArticle> _favorites = [];
  List<NewsArticle> get favorites => _favorites;

  // Load favorites when the app starts
  NewsProvider() {
    _loadFavorites();
  }

  bool isFavorite(NewsArticle article) {
    return _favorites.any((fav) => fav.url == article.url);
  }


  final String _apiKey = '69de8a05ee9840e69f48bf2e167e672a';

  Future<void> fetchNews({String category = ''}) async {
    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$_apiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];
        _articles = articlesJson.map((json) => NewsArticle.fromJson(json))
            .toList();
        _filteredArticles = List.from(_articles);
        notifyListeners();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void searchArticles(String query) {
    if (query.isEmpty) {
      _filteredArticles = List.from(_articles);
    } else {
      _filteredArticles = _articles
          .where((article) =>
          article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> addToFavorites(NewsArticle article) async {
    _favorites.add(article);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFromFavorites(NewsArticle article) async {
    _favorites.removeWhere((fav) => fav.url == article.url);
    await _saveFavorites();
    notifyListeners();
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteUrls = _favorites.map((a) => a.url).toList();
    prefs.setStringList('favoriteArticles', favoriteUrls);
  }


  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteUrls = prefs.getStringList('favoriteArticles');

    if (favoriteUrls != null) {
      _favorites = _articles
          .where((article) => favoriteUrls.contains(article.url))
          .toList();
    }
    notifyListeners();
  }
}
