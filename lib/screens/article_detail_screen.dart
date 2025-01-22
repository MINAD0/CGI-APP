import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    final String articleTitle = "Article ${article['numero'] ?? 'N/A'}";
    final String articleContent = article['contenu'] ?? 'Pas de contenu disponible';

    return Scaffold(
      appBar: AppBar(
        title: Text(articleTitle),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.5, // Minimum zoom scale
        maxScale: 5.0, // Maximum zoom scale
        boundaryMargin: const EdgeInsets.all(20), // Allows panning beyond the screen edges
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _parseContent(articleContent),
          ),
        ),
      ),
    );
  }

  List<Widget> _parseContent(String content) {
    List<Widget> widgets = [];

    content = content
        .replaceAll(';', '\n')
        .replaceAll(':', ':\n')
        .replaceAllMapped(
            RegExp(r'(I\.|II\.|III\.|1°|2°|3°|1\-|2\-|3\-|A\-|B\-|C\-)'),
            (match) => '\n${match.group(0)}');

    List<String> lines = content.split('\n');

    for (String line in lines) {
      line = line.trim();

      if (line.startsWith('I.') || line.startsWith('II.') || line.startsWith('III.')) {
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
      } else if (line.startsWith('1°') || line.startsWith('2°') || line.startsWith('3°')) {
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
      } else if (line.startsWith('A-') || line.startsWith('B-') || line.startsWith('C-')) {
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
