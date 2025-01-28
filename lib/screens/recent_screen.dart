import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../recent_provider.dart';
import 'chapitre_screen.dart';

class RecentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recent Articles", style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.teal : Colors.white,
        elevation: 2,
      ),
      body: Consumer<RecentProvider>(
        builder: (context, recentProvider, child) {
          final recentItems = recentProvider.recentItems;

          return recentItems.isEmpty
              ? _buildEmptyState(isDarkMode)
              : _buildRecentList(recentItems, isDarkMode, context);
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 60, color: isDarkMode ? Colors.grey : Colors.blueAccent),
          const SizedBox(height: 16),
          Text('No recent Articles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.grey : Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildRecentList(List<Map<String, dynamic>> recentItems, bool isDarkMode, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: recentItems.length,
      itemBuilder: (context, index) {
        final livre = recentItems[index];
        String titreText = livre['livre'] ?? 'Titre Inconnu';
        List<String> titreParts = titreText.split(';');
        String titreMain = titreParts[0].trim();
        String titreSub = titreParts.length > 1 ? titreParts[1].trim() : '';
        // print(titreMain);

        return RecentCard(
          livre: livre,
          isDarkMode: isDarkMode,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChapitreScreen(
                  titre: titreMain ?? 'Unknown Title',
                  chapitres: livre['chapitres'] ?? [], // Pass full chapitres
                  livreTitle: livre['chapitre'] ?? 'Unknown Title',
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class RecentCard extends StatelessWidget {
  final Map<String, dynamic> livre;
  final bool isDarkMode;
  final VoidCallback onTap;

  const RecentCard({required this.livre, required this.isDarkMode, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String titreText = livre['livre'] ?? 'Titre Inconnu';
    List<String> titreParts = titreText.split(';');
    String titreMain = titreParts[0].trim();
    String titreSub = titreParts.length > 1 ? titreParts[1].trim() : '';
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.history, size: 36, color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titreMain, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(titreSub, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue)),
                    const SizedBox(height: 4),
                    const Text("Récemment ouverte", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
