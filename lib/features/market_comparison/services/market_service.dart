import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/market_model.dart';

class MarketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'markets';

  // Tüm marketleri getir
  Stream<List<MarketModel>> getMarkets() {
    return _firestore
        .collection(_collection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      try {
        final markets = snapshot.docs.map((doc) {
          try {
            final data = doc.data();
            // Market verisi doğrulama
            if (_isValidMarketData(data)) {
              return MarketModel.fromJson(data);
            }
            return null;
          } catch (e) {
            print('Market dönüştürme hatası: $e');
            return null;
          }
        }).whereType<MarketModel>().toList();

        // Eğer hiç geçerli market yoksa varsayılan market listesini döndür
        if (markets.isEmpty) {
          return _getDefaultMarkets();
        }

        return markets;
      } catch (e) {
        print('Market listesi oluşturma hatası: $e');
        return _getDefaultMarkets();
      }
    });
  }

  bool _isValidMarketData(Map<String, dynamic> data) {
    return data.containsKey('name') &&
        data.containsKey('status') &&
        data.containsKey('logo') &&
        data['name'] != null &&
        data['name'].toString().isNotEmpty;
  }

  List<MarketModel> _getDefaultMarkets() {
    return [
      MarketModel(
        id: 'default',
        name: 'Varsayılan Market',
        logo: 'assets/images/markets/default_logo.png',
        status: 'Kapalı',
        distance: '',
        address: '',
        rating: 0,
        website: '',
        categories: ['Market'],
        lastUpdated: DateTime.now(),
      ),
    ];
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
