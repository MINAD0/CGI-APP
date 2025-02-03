import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'article_detail_screen.dart';
import '../recent_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  Future<void> searchArticles(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String jsonString = await rootBundle.loadString('assets/output2025.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> livres = jsonData['livres'] ?? [];

      List<Map<String, dynamic>> results = [];
      
      for (var livre in livres) {
        String livreTitle = livre['titre'] ?? 'Livre Inconnu';
        
        for (var titre in (livre['titres'] ?? [])) {
          String titreTitle = titre['titre'] ?? 'Titre Inconnu';
          
          for (var chapitre in (titre['chapitres'] ?? [])) {
            String chapitreTitle = chapitre['titre'] ?? 'Chapitre Inconnu';
            
            for (var article in (chapitre['articles'] ?? [])) {
              if (article['contenu'].toString().toLowerCase().contains(query.toLowerCase()) ||
                  article['numero'].toString().toLowerCase().contains(query.toLowerCase())) {
                results.add({
                  'article': article,
                  'livre': livreTitle,
                  'titre': titreTitle,
                  'chapitre': chapitreTitle,
                });
              }
            }
          }
        }
      }

      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.teal : Colors.white,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Rechercher des articles...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onChanged: (value) {
            searchQuery = value;
            searchArticles(value);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : searchResults.isEmpty
              ? Center(
                  child: Text(
                    searchQuery.isEmpty
                        ? 'Commencez à taper pour rechercher'
                        : 'Aucun résultat trouvé',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final result = searchResults[index];
                    final article = result['article'];
                    
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          'Article ${article['numero']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          article['contenu'].toString().substring(0, 
                            article['contenu'].toString().length > 100 
                              ? 100 
                              : article['contenu'].toString().length
                          ) + '...',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        onTap: () {
                          final recentProvider = Provider.of<RecentProvider>(
                            context, 
                            listen: false
                          );
                          recentProvider.addToRecent(result);
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(
                                article: {
                                  ...article,
                                  'livre': result['livre'],
                                  'titre': result['titre'],
                                  'chapitre': result['chapitre'],
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
