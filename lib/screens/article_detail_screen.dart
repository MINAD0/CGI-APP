import 'package:flutter/material.dart';
import '../bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;

  ArticleDetailScreen({required this.article});

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final isBookmarked = bookmarkProvider.isBookmarked(widget.article);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final headerColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final String articleTitle = "Article ${widget.article['numero'] ?? 'N/A'}";
    final String articleContent = widget.article['contenu'] ?? 'Pas de contenu disponible';
    final String livre = widget.article['livre'] ?? 'Livre inconnu';
    List<String> partes = livre.split(';');
    String mainTitleL = partes[0].trim();
    final String titre = widget.article['titre'] ?? 'Titre inconnu';
    final String chapitre = widget.article['chapitre'] ?? 'Chapitre inconnu';
    List<String> parts = chapitre.split(';');
    String mainTitle = parts[0].trim();
    String subTitre = parts.length > 1 ? parts[1].trim() : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(articleTitle),
        backgroundColor: isDarkMode ? Colors.teal : Color.fromARGB(255, 228, 228, 228),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: isDarkMode ? Colors.orangeAccent : Colors.deepOrange,
            ),
            onPressed: () {
              if (isBookmarked) {
                bookmarkProvider.removeBookmark(widget.article);
              } else {
                bookmarkProvider.addBookmark(widget.article);
              }
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Logo
                        Image.asset(
                          'assets/logo.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/book-solid.svg',
                                    height: 15,
                                    width: 15,
                                    color: isDarkMode ? Colors.white54 : Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Livre: $mainTitleL',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/paperclip-solid.svg',
                                    height: 15,
                                    width: 15,
                                    color: isDarkMode ? Colors.white54 : Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '$titre',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/folder-open-regular.svg',
                                    height: 15,
                                    width: 15,
                                    color: isDarkMode ? Colors.white54 : Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '$mainTitle',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '$subTitre',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Article Content Card
              Card(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _parseContent(articleContent, isDarkMode),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _parseContent(String content, bool isDarkMode) {
    List<Widget> widgets = [];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    content = content
        .replaceAll(';', '\n')
        .replaceAll(':', ':\n')
        .replaceAllMapped(
        RegExp(r'(I\.|II\.|III\.|1°|2°|3°|1\-|2\-|3\-|A\-|B\-|C\-)'),
            (match) => '\n${match.group(0)}');

    List<String> lines = content.split('\n');

    for (String line in lines) {
      line = line.trim();

      if (line.startsWith('I.') ||
          line.startsWith('II.') ||
          line.startsWith('III.')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        );
      } else if (line.startsWith('1°') ||
          line.startsWith('2°') ||
          line.startsWith('3°')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
        );
      } else if (line.startsWith('A-') ||
          line.startsWith('B-') ||
          line.startsWith('C-')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: textColor,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        );
      }
    }
    return widgets;
  }
}