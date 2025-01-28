import 'package:flutter/material.dart';

class RecentProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _recentItems = [];

  List<Map<String, dynamic>> get recentItems => List.unmodifiable(_recentItems);

  void addToRecent(Map<String, dynamic> item) {
    // Remove duplicate if it already exists
    _recentItems.removeWhere((existingItem) => existingItem['livre'] == item['livre']);

    // Add new item with full data (titres, chapitres, articles)
    _recentItems.insert(0, {
      'livre': item['livre'],
      'titres': item['titres'],
      'chapitres': item['chapitres'] ?? [], // Include chapitres
      'articles': item['articles'] ?? [],   // Include articles if available
    });

    // Keep the list to a maximum of 10 items
    if (_recentItems.length > 10) {
      _recentItems.removeLast();
    }
    notifyListeners();
  }
}
