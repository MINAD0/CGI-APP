import 'package:flutter/material.dart';
import 'article_detail_screen.dart';

class ChapitreScreen extends StatelessWidget {
  final String titre;
  final List<dynamic> chapitres;
  final bool isDarkMode;

  ChapitreScreen({
    required this.titre,
    required this.chapitres,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black12;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.teal : Colors.blueAccent,
        title: Text(
          titre,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: chapitres.length,
          itemBuilder: (context, index) {
            final chapitre = chapitres[index];
            return _buildChapitreTile(context, chapitre, textColor);
          },
        ),
      ),
    );
  }

  Widget _buildChapitreTile(
      BuildContext context, Map<String, dynamic> chapitre, Color textColor) {
    final String chapitreTitre = chapitre['titre'] ?? 'Sans Titre';
    final List<dynamic> sections = chapitre['sections'] ?? [];
    final List<dynamic> articles = chapitre['articles'] ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          chapitreTitre,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
          ),
        ),
        children: sections.isNotEmpty
            ? sections
                .map((section) => _buildSectionTile(context, section))
                .toList()
            : articles
                .map((article) => _buildArticleTile(context, article))
                .toList(),
      ),
    );
  }

  Widget _buildSectionTile(BuildContext context, Map<String, dynamic> section) {
    final String sectionTitle = section['titre'] ?? 'Sans Titre';
    final List<dynamic> articles = section['articles'] ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          sectionTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.teal,
          ),
        ),
        children: articles
            .map((article) => _buildArticleTile(context, article))
            .toList(),
      ),
    );
  }

  Widget _buildArticleTile(BuildContext context, Map<String, dynamic> article) {
    final String articleTitle = "Article ${article['numero'] ?? 'Sans Titre'}";
    final String articlePreview =
        (article['contenu'] ?? '').split(' ').take(10).join(' ') + '...';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          articleTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange,
          ),
        ),
        subtitle: Text(
          articlePreview,
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
        leading: Icon(Icons.article, color: Colors.deepOrange),
      ),
    );
  }
}
