import 'package:flutter/material.dart';
import '../bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;
  final List<Map<String, dynamic>>? articles;
  final int? currentIndex;

  ArticleDetailScreen({
    required this.article, 
    this.articles,
    this.currentIndex,
  });

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  late Map<String, dynamic> _currentArticle;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
    _currentArticle = widget.article;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final isBookmarked = bookmarkProvider.isBookmarked(_currentArticle);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final headerColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final String articleTitle = "Article ${_currentArticle['numero'] ?? 'N/A'}";
    final String articleContent = _currentArticle['contenu'] ?? 'Pas de contenu disponible';
    final String livre = _currentArticle['livre'] ?? 'Livre inconnu';
    List<String> partes = livre.split(';');
    String mainTitleL = partes[0].trim();
    final String titre = _currentArticle['titre'] ?? 'Titre inconnu';
    final String chapitre = _currentArticle['chapitre'] ?? 'Chapitre inconnu';
    List<String> parts = chapitre.split(';');
    String mainTitle = parts[0].trim();
    String subTitre = parts.length > 1 ? parts[1].trim() : '';
    final String? section = _currentArticle['section'];

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
          if (widget.articles != null) ...[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: _currentIndex > 0
                  ? () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              color: _currentIndex > 0 
                  ? (isDarkMode ? Colors.white : Colors.black)
                  : Colors.grey,
            ),
            Text(
              "${_currentIndex + 1}/${widget.articles!.length}",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: widget.articles != null && 
                        _currentIndex < widget.articles!.length - 1
                  ? () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              color: widget.articles != null && 
                     _currentIndex < widget.articles!.length - 1
                  ? (isDarkMode ? Colors.white : Colors.black)
                  : Colors.grey,
            ),
          ],
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: isDarkMode ? Colors.orangeAccent : Colors.deepOrange,
            ),
            onPressed: () {
              if (isBookmarked) {
                bookmarkProvider.removeBookmark(_currentArticle);
              } else {
                bookmarkProvider.addBookmark(_currentArticle);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          widget.articles == null
              ? _buildArticleContent(_currentArticle, isDarkMode)
              : PageView.builder(
                  controller: _pageController,
                  itemCount: widget.articles!.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                      _currentArticle = widget.articles![index];
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildArticleContent(widget.articles![index], isDarkMode);
                  },
                ),
          if (widget.articles != null) ...[
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _currentIndex > 0
                  ? Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: _currentIndex < (widget.articles?.length ?? 0) - 1
                  ? Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArticleContent(Map<String, dynamic> article, bool isDarkMode) {
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final headerColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final String articleTitle = "Article ${article['numero'] ?? 'N/A'}";
    final String articleContent = article['contenu'] ?? 'Pas de contenu disponible';
    
    final String livre = article['livre'] ?? 'Livre inconnu';
    final String titre = article['titre'] ?? 'Titre inconnu';
    final String chapitre = article['chapitre'] ?? 'Chapitre inconnu';
    final String subTitre = article['subTitre'] ?? '';
    final String? section = article['section'];

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode ? Colors.teal.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Livre
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/book-solid.svg',
                                  height: 20,
                                  width: 20,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    livre,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Titre
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/link-solid.svg',
                                  height: 20,
                                  width: 20,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    titre,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Chapitre
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/folder-open-regular.svg',
                                  height: 20,
                                  width: 20,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    chapitre,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (subTitre.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 32),
                                child: Text(
                                  subTitre,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                            if (section != null) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/paperclip-solid.svg',
                                    height: 20,
                                    width: 20,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      section,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Article Content Card
            Card(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDarkMode ? Colors.teal.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                ),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _parseContent(articleContent, isDarkMode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _parseContent(String content, bool isDarkMode) {
    List<Widget> widgets = [];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // First, split by specific delimiters
    content = content
        .replaceAll(';', ';\n')  // Add newline after semicolons
        .replaceAll(':', ':\n')  // Add newline after colons
        .replaceAll(' -', '\n-') // Add newline before dashes
        .replaceAllMapped(
            RegExp(r'((?:^|\s)(?:I\.|II\.|III\.|[1-9]°-|[1-9]°|[1-9]-|A-|B-|C-))'),
            (match) => '\n${match.group(0)}'); // Add newline before numbered items

    List<String> lines = content.split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    for (String line in lines) {
      if (line.startsWith('I.') || 
          line.startsWith('II.') || 
          line.startsWith('III.')) {
        // Main sections
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.lightBlueAccent : Colors.blue[700],
              ),
            ),
          ),
        );
      } else if (RegExp(r'^[1-9]°-|^[1-9]°').hasMatch(line)) {
        // Numbered items with degree symbol
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.greenAccent : Colors.green[700],
              ),
            ),
          ),
        );
      } else if (RegExp(r'^[1-9]-').hasMatch(line)) {
        // Numbered items with dash
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 4.0, bottom: 4.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.orangeAccent : Colors.orange[700],
              ),
            ),
          ),
        );
      } else if (line.startsWith('A-') || 
                 line.startsWith('B-') || 
                 line.startsWith('C-')) {
        // Lettered items
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.purpleAccent : Colors.purple[700],
              ),
            ),
          ),
        );
      } else if (line.startsWith('-')) {
        // Simple bullet points
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: textColor,
              ),
            ),
          ),
        );
      } else {
        // Regular text
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
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