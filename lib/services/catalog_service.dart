import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/catalog_model.dart';

class CatalogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Catalog>> getCatalogs() {
    return _firestore.collection('catalogs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Catalog.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> updateCatalog(String marketName, String imageUrl) async {
    await _firestore.collection('catalogs').doc(marketName).set({
      'imageUrl': imageUrl,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
}
