import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/barcode_service.dart';

class MarketProvider with ChangeNotifier {
  final BarcodeService _barcodeService = BarcodeService();
  ProductModel? _currentProduct;
  bool _isLoading = false;
  List<Map<String, dynamic>> _markets = [
    {'name': 'A101', 'logo': '🏪', 'status': 'Açık'},
    {'name': 'BİM', 'logo': '🏪', 'status': 'Açık'},
    {'name': 'ŞOK', 'logo': '🏪', 'status': 'Kapalı'},
    {'name': 'Migros', 'logo': '🏬', 'status': 'Açık'},
    {'name': 'CarrefourSA', 'logo': '🏬', 'status': 'Açık'},
  ];

  ProductModel? get currentProduct => _currentProduct;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get markets => _markets;

  Future<void> searchByBarcode(String barcode) async {
    _setLoading(true);
    try {
      final productData = await _barcodeService.getProductByBarcode(barcode);
      if (productData != null) {
        _currentProduct = ProductModel.fromJson(productData);
      } else {
        _currentProduct = null;
      }
      notifyListeners();
    } catch (e) {
      print('Ürün arama hatası: $e');
      _currentProduct = null;
    }
    _setLoading(false);
  }

  Future<void> searchByText(String query) async {
    _setLoading(true);
    try {
      // TODO: Implement text search
      notifyListeners();
    } catch (e) {
      print('Metin arama hatası: $e');
    }
    _setLoading(false);
  }

  void updateMarketStatus(String marketName, String status) {
    final index = _markets.indexWhere((market) => market['name'] == marketName);
    if (index != -1) {
      _markets[index]['status'] = status;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
