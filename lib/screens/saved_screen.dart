import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bookmark_provider.dart';
import 'article_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Article Enregistré',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.teal : Colors.white,
        elevation: 2,
      ),
      body: bookmarkProvider.bookmarkedArticles.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 60,
              color: isDarkMode ? Colors.grey : Colors.blueAccent,
            ),
            SizedBox(height: 16),
            Text(
              'No Saved Articles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey : Colors.black87,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookmarkProvider.bookmarkedArticles.length,
        itemBuilder: (context, index) {
          final article = bookmarkProvider.bookmarkedArticles[index];
          return _buildArticleCard(context, article, isDarkMode);
        },
      ),
    );
  }

  Widget _buildArticleCard(
      BuildContext context, Map<String, dynamic> article, bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: isDarkMode ? Colors.blueAccent : Colors.orangeAccent,
          child: Icon(
            Icons.article,
            color: Colors.white,
          ),
        ),
        title: Text(
          article['titre'] ?? 'Titre inconnu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        subtitle: Text(
          'Article ${article['numero'] ?? 'N/A'}',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          size: 18,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(
                article: article,
              ),
            ),
          );
        },
      ),
    );
  }
}
