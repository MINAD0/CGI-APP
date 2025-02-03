import 'package:flutter/material.dart';
import 'article_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChapitreScreen extends StatelessWidget {
  final List<dynamic> chapitres;
  final String livre;
  final String titre;

  ChapitreScreen({
    required this.chapitres,
    required this.livre,
    required this.titre,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor =
    isDarkMode ? Colors.teal : const Color.fromARGB(255, 228, 228, 228);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          titre,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
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
            return _buildChapitreTile(
              context,
              chapitre,
              textColor,
              cardColor,
              isDarkMode,
              livre,
            );
          },
        ),
      ),
    );
  }

  Widget _buildChapitreTile(
      BuildContext context,
      Map<String, dynamic> chapitre,
      Color textColor,
      Color? cardColor,
      bool isDarkMode,
      String livre,
      ) {
    final String chapitreTitre = chapitre['titre'] ?? 'Sans Titre';
    List<String> titreParts = chapitreTitre.split(';');
    String mainTitre = titreParts[0].trim(); // Part before the semicolon
    String subTitre = titreParts.length > 1 ? titreParts[1].trim() : ''; // Part after the semicolon
    final List<dynamic> sections = chapitre['sections'] ?? [];
    final List<dynamic> articles = chapitre['articles'] ?? [];

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ExpansionTile(
        tilePadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/folder-open-regular.svg', // Path to the SVG file
                  height: 20,
                  width: 20,
                  color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
                ),
                const SizedBox(width: 8), // Space between icon and text
                Expanded(
                  child: Text(
                    mainTitre,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subTitre,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
        children: sections.isNotEmpty
            ? sections
                .map((section) => _buildSectionTile(
                      context,
                      section,
                      chapitreTitre,
                      textColor,
                      cardColor,
                      isDarkMode,
                      livre,
                    ))
                .toList()
            : articles
                .map((article) => _buildArticleTile(
                      context,
                      article,
                      livre,
                      chapitre['titre'] ?? 'Sans Titre',
                      this.titre,
                      isDarkMode,
                    ))
                .toList(),
      ),
    );
  }

  Widget _buildSectionTile(
      BuildContext context,
      Map<String, dynamic> section,
      String chapitreTitre,
      Color textColor,
      Color? cardColor,
      bool isDarkMode,
      String livre,
      ) {
    final String sectionTitle = section['titre'] ?? 'Sans Titre';
    final List<dynamic> articles = section['articles'] ?? [];

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ExpansionTile(
        tilePadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          sectionTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.lightGreenAccent : Colors.teal,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        children: articles
            .map((article) => _buildArticleTile(
          context,
          article,
          livre,
          chapitreTitre,
          sectionTitle,
          isDarkMode,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildArticleTile(
      BuildContext context,
      Map<String, dynamic> article,
      String livre,
      String chapitre,
      String titre,
      bool isDarkMode,
      ) {
    final String articleTitle = "Article ${article['numero'] ?? 'Sans Titre'}";
    final String articlePreview =
        (article['contenu'] ?? '').split(' ').take(10).join(' ') + '...';

    // Extract subtitle from chapitre
    List<String> parts = chapitre.split(';');
    String mainTitle = parts[0].trim();
    String subTitre = parts.length > 1 ? parts[1].trim() : '';

    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text(
        articleTitle,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        articlePreview,
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.grey[400] : Colors.black54,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      leading: SvgPicture.asset(
        'assets/icons/newspaper-regular.svg',
        height: 20,
        width: 20,
        color: isDarkMode ? Colors.orangeAccent : Colors.teal,
      ),
      onTap: () {
        List<Map<String, dynamic>> chapterArticles = [];
        
        // Find the current chapter
        var currentChapter = chapitres.firstWhere(
          (chap) => chap['titre'] == chapitre,
          orElse: () => null,
        );

        if (currentChapter != null) {
          if (currentChapter['sections'] != null && 
              currentChapter['sections'].any((s) => s['titre'] == titre)) {
            var currentSection = currentChapter['sections'].firstWhere(
              (section) => section['titre'] == titre,
              orElse: () => null,
            );

            if (currentSection != null) {
              chapterArticles = (currentSection['articles'] as List? ?? [])
                  .map((a) => {
                        ...a as Map<String, dynamic>,
                        'livre': this.livre,
                        'chapitre': mainTitle,
                        'section': titre,
                        'titre': this.titre,
                        'subTitre': subTitre,
                      })
                  .toList()
                  .cast<Map<String, dynamic>>();
            }
          } else {
            chapterArticles = (currentChapter['articles'] as List? ?? [])
                .map((a) => {
                      ...a as Map<String, dynamic>,
                      'livre': this.livre,
                      'chapitre': mainTitle,
                      'titre': this.titre,
                      'subTitre': subTitre,
                    })
                .toList()
                .cast<Map<String, dynamic>>();
          }
        }

        // Safety check to ensure we have articles
        if (chapterArticles.isEmpty) {
          print('No articles found');
          return;
        }

        // Find the index of the current article
        final currentIndex = chapterArticles.indexWhere(
          (a) => a['numero'] == article['numero']
        );

        // Safety check for valid index
        if (currentIndex == -1) {
          print('Article not found');
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              article: {
                ...article,
                'livre': this.livre,
                'titre': this.titre,
                'chapitre': mainTitle,
                'subTitre': subTitre,
              },
              articles: chapterArticles,
              currentIndex: currentIndex,
            ),
          ),
        );
      },
    );
  }
}