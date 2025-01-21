import 'package:flutter/material.dart';

class RecentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recent Articles")),
      body: Center(child: Text("Recent Articles")),
    );
  }
}

class EnregistreArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enregistre Articles")),
      body: Center(child: Text("Saved Articles")),
    );
  }
}
