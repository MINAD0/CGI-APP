import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'chapitre_screen.dart';
import 'theme_notifier.dart';
import 'article_detail_screen.dart';
import 'package:provider/provider.dart';
import '../recent_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _livresData = [];
  List<dynamic> _filteredResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterResults);
  }

  Future<void> _loadData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/output2025.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);

      List<dynamic> livres = jsonData['livres'] ?? [];
      setState(() {
        _livresData = livres
            .map((livre) => {
          'livre': livre['titre'] ?? 'Livre Inconnu',
          'titres': livre['titres'] ?? [],
        })
            .toList()
            .cast<Map<String, dynamic>>();
        _filteredResults = _livresData; // Initially show "livres"
      });
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  void _filterResults() {
    final query = _searchController.text.toLowerCase().trim();
    final articleMatch = RegExp(r'article\s+(\d+)').firstMatch(query);

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredResults = _livresData;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredResults = [];

      for (final livre in _livresData) {
        String livreTitle = livre['livre'] ?? 'Livre Inconnu';
        
        for (final titre in (livre['titres'] ?? [])) {
          String titreTitle = titre['titre'] ?? 'Titre Inconnu';
          
          for (final chapitre in (titre['chapitres'] ?? [])) {
            String chapitreTitle = chapitre['titre'] ?? 'Chapitre Inconnu';
            
            for (final article in (chapitre['articles'] ?? [])) {
              final articleNumber = (article['numero'] ?? '').toString().toLowerCase();
              final articleContent = (article['contenu'] ?? '').toString().toLowerCase();

              if (articleMatch != null) {
                final searchedNumber = articleMatch.group(1)!;
                if (articleNumber == searchedNumber) {
                  _filteredResults.add({
                    'type': 'article',
                    'article': {
                      ...article,
                      'livre': livreTitle,
                      'titre': titreTitle,
                      'chapitre': chapitreTitle,
                    },
                    'livre': livreTitle,
                    'chapitre': chapitreTitle,
                    'titre': titreTitle,
                  });
                }
              } else if (articleContent.contains(query)) {
                _filteredResults.add({
                  'type': 'article',
                  'article': {
                    ...article,
                    'livre': livreTitle,
                    'titre': titreTitle,
                    'chapitre': chapitreTitle,
                  },
                  'livre': livreTitle,
                  'chapitre': chapitreTitle,
                  'titre': titreTitle,
                });
              }
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.teal : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        title: Text('Code Général des Impôts'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            height: 30,
            width: 30,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeNotifier>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Articles...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredResults.length,
                itemBuilder: (context, index) {
                  final result = _filteredResults[index];
                  return _isSearching
                      ? _buildSearchCard(context, result, isDarkMode)
                      : _buildLivreAccordion(context, result, index, isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivreAccordion(BuildContext context, Map<String, dynamic> livre, int index, bool isDarkMode) {
    String livreTitle = livre['livre'] ?? 'Livre Inconnu';
    List<String> parts = livreTitle.split(';');
    String mainTitle = parts[0].trim();
    String subTitle = parts.length > 1 ? parts[1].trim() : '';

    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add logo
            Image.asset(
              'assets/cgi_logo.png',
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10), // Space between logo and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Title
                  Text(
                    mainTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Separation space
                  // Sub Title with lighter color
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Divider(height: 10, thickness: 1, color: Colors.grey), // Line Separator
                ],
              ),
            ),
          ],
        ),
        children: (livre['titres'] ?? []).map<Widget>((titre) {
          String titreText = titre['titre'] ?? 'Titre Inconnu';
          List<String> titreParts = titreText.split(';');
          String titreMain = titreParts[0].trim();
          String titreSub = titreParts.length > 1 ? titreParts[1].trim() : '';

          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titreMain,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  titreSub,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              final recentProvider = Provider.of<RecentProvider>(context, listen: false);
              recentProvider.addToRecent({
                'livre': livre['livre'],
                'titres': livre['titres'],
                'chapitres': titre['chapitres'] ?? [],
              });

              // Extract the main titles before semicolon
              String livreTitle = livre['livre'].toString().split(';')[0].trim();
              String titreTitle = titre['titre'].toString().split(';')[0].trim();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapitreScreen(
                    chapitres: titre['chapitres'] ?? [],
                    livre: livreTitle,  // Pass the main livre title
                    titre: titreTitle,  // Pass the main titre title
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context, Map<String, dynamic> result, bool isDarkMode) {
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;

    if (result['type'] == 'article') {
      final article = result['article'];
      final recentProvider =
      Provider.of<RecentProvider>(context, listen: false);
      return Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          title: Text(
            "Article ${article['numero'] ?? 'N/A'}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Text(
            (article['contenu'] ?? '').split(' ').take(10).join(' ') + '...',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onTap: () {
            recentProvider.addToRecent({
              'article': article,
              'livre': result['livre'],
              'chapitre': result['chapitre'],
              'titre': result['titre'],
            });
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
    }

    return SizedBox.shrink();
  }
}
