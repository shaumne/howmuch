import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/catalog_model.dart';

class CatalogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Onay bekleyen katalogları getir (Admin için)
  Stream<List<CatalogModel>> getPendingCatalogs() {
    return _firestore
        .collection('catalogs')
        .where('isApproved', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CatalogModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Onaylanmış katalogları getir (Normal kullanıcılar için)
  Stream<List<CatalogModel>> getApprovedCatalogs() {
    return _firestore
        .collection('catalogs')
        .where('isApproved', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .orderBy('__name__', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) {
              final endDate = doc['endDate'] as Timestamp;
              return endDate.toDate().isAfter(DateTime.now());
            })
            .map((doc) => CatalogModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Katalog onaylama
  Future<void> approveCatalog(String catalogId) async {
    await _firestore.collection('catalogs').doc(catalogId).update({
      'isApproved': true,
      'approvedAt': FieldValue.serverTimestamp(),
    });
  }

  // Katalog reddetme
  Future<void> rejectCatalog(String catalogId, String reason) async {
    await _firestore.collection('catalogs').doc(catalogId).update({
      'isApproved': false,
      'rejectionReason': reason,
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }
} 