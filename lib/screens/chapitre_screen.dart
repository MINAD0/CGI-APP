import 'package:flutter/material.dart';
import 'article_detail_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChapitreScreen extends StatelessWidget {
  final String titre;
  final List<dynamic> chapitres;
  final String livreTitle;

  ChapitreScreen({
    required this.titre,
    required this.chapitres,
    required this.livreTitle,
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
              livreTitle,
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
      String livreTitle,
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
        ))
            .toList()
            : articles
            .map((article) => _buildArticleTile(
          context,
          article,
          chapitre['livre'] ?? 'Livre inconnu',
          chapitreTitre,
          titre,
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
          section['livre'] ?? 'Livre inconnu',
          chapitreTitre,
          titre,
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
        'assets/icons/newspaper-regular.svg', // Path to your SVG file
        height: 20, // Adjust size as needed
        width: 20,
        color: isDarkMode ? Colors.orangeAccent : Colors.teal,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              article: {
                ...article,
                'livre': livre,
                'chapitre': chapitre,
                'titre': titre,
                'livre': livreTitle,
              },
            ),
          ),
        );
      },
    );
  }
}