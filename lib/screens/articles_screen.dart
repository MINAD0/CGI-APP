import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesScreen extends StatelessWidget {
  final String chapitreId;

  const ArticlesScreen({Key? key, required this.chapitreId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collectionGroup('articles')
            .where('chapitreId', isEqualTo: chapitreId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['numero']),
                subtitle: Text(doc['contenu']),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/articleDetail',
                    arguments: doc.data(),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
