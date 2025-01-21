import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'chapitre_screen.dart';
import 'theme_notifier.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _livresData = [];
  List<Map<String, dynamic>> _filteredLivres = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterLivres);
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
        _filteredLivres = List<Map<String, dynamic>>.from(_livresData);
      });
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  void _filterLivres() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLivres = _livresData.where((item) {
        return (item['livre'] ?? '').toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                hintText: 'Search Livres or Titres...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredLivres.length,
                itemBuilder: (context, index) {
                  final livre = _filteredLivres[index];
                  return _buildLivreAccordion(livre);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildLivreAccordion(Map<String, dynamic> livre) {
  String livreTitle = livre['livre'] ?? 'Livre Inconnu';
  List<String> parts = livreTitle.split(';');
  String mainTitle = parts[0].trim(); // Part before semicolon
  String subTitle = parts.length > 1 ? parts[1].trim() : ''; // Part after semicolon

  return Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mainTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4), // Small space between title and subtitle
          Text(
            subTitle,
            style: TextStyle(
              color: const Color.fromARGB(255, 9, 55, 204),
              fontSize: 14,
            ),
          ),
        ],
      ),
      leading: Icon(Icons.book, color: Colors.blueAccent),
      children: (livre['titres'] as List).map((titre) {
        return ListTile(
          title: Text(
            titre['titre'] ?? 'Titre Inconnu',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChapitreScreen(
                  titre: titre['titre'] ?? 'Titre Inconnu',
                  chapitres: titre['chapitres'] ?? [],
                  isDarkMode: false,
                ),
              ),
            );
          },
        );
      }).toList(),
    ),
  );
}

}
