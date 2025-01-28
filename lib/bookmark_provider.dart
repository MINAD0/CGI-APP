import 'package:flutter/material.dart';

class BookmarkProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _bookmarkedArticles = [];

  List<Map<String, dynamic>> get bookmarkedArticles => _bookmarkedArticles;

  void addBookmark(Map<String, dynamic> article) {
    if (!_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.add(article);
      notifyListeners();
    }
  }

  void removeBookmark(Map<String, dynamic> article) {
    _bookmarkedArticles.remove(article);
    notifyListeners();
  }

  bool isBookmarked(Map<String, dynamic> article) {
    return _bookmarkedArticles.contains(article);
  }
}
