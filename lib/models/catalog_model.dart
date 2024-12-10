import 'package:cloud_firestore/cloud_firestore.dart';

class Catalog {
  final String marketName;
  final String imageUrl;
  final DateTime lastUpdated;

  Catalog({
    required this.marketName,
    required this.imageUrl,
    required this.lastUpdated,
  });

  factory Catalog.fromFirestore(Map<String, dynamic> data, String id) {
    return Catalog(
      marketName: id,
      imageUrl: data['imageUrl'] as String,
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }
}
