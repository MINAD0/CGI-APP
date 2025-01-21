import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List searchResults = [];

  void searchArticles(String query) async {
    final collection = FirebaseFirestore.instance.collection('livres');
    final results = await collection.get();

    List filtered = [];
    for (var doc in results.docs) {
      for (var titre in doc['titres']) {
        for (var chapitre in titre['chapitres']) {
          for (var article in chapitre['articles']) {
            if (article['contenu'].toLowerCase().contains(query.toLowerCase())) {
              filtered.add(article);
            }
          }
        }
      }
    }

    setState(() {
      searchResults = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Rechercher des articles...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            searchQuery = value;
            searchArticles(value);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final article = searchResults[index];
          return ListTile(
            title: Text('Article ${article['numero']}'),
            subtitle: Text(article['contenu']),
          );
        },
      ),
    );
  }
}
