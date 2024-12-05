import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/market_model.dart';

class MarketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'markets';

  // Tüm marketleri getir
  Stream<List<MarketModel>> getMarkets() {
    return _firestore.collection(_collection).orderBy('name').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => MarketModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Market detaylarını getir
  Future<MarketModel?> getMarketById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return MarketModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Market durumunu güncelle
  Future<void> updateMarketStatus(String id, String status) async {
    await _firestore.collection(_collection).doc(id).update({
      'status': status,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Yeni market ekle (admin için)
  Future<void> addMarket(MarketModel market) async {
    await _firestore
        .collection(_collection)
        .doc(market.id)
        .set(market.toJson());
  }

  // Market bilgilerini güncelle (admin için)
  Future<void> updateMarket(MarketModel market) async {
    await _firestore
        .collection(_collection)
        .doc(market.id)
        .update(market.toJson());
  }
}
