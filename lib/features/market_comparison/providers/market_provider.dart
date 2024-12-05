import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/market_model.dart';
import '../services/market_service.dart';
import '../models/product_model.dart';
import '../services/barcode_service.dart';
import '../services/location_service.dart';

class MarketProvider with ChangeNotifier {
  final MarketService _marketService = MarketService();
  final BarcodeService _barcodeService = BarcodeService();
  final LocationService _locationService = LocationService();

  List<MarketModel> _markets = [];
  ProductModel? _currentProduct;
  bool _isLoading = false;
  String? _error;
  Position? _currentLocation;

  List<MarketModel> get markets => _markets;
  ProductModel? get currentProduct => _currentProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentLocation => _currentLocation;

  // Market verilerini dinle
  void initMarkets() {
    _setLoading(true);
    _marketService.getMarkets().listen(
      (marketList) {
        _markets = marketList;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Market verilerini alırken bir hata oluştu: $e';
        print(_error);
        notifyListeners();
      },
    );
    _setLoading(false);
  }

  // Market durumunu güncelle
  Future<void> updateMarketStatus(String marketId, String status) async {
    try {
      await _marketService.updateMarketStatus(marketId, status);
      _error = null;
    } catch (e) {
      _error = 'Market durumu güncellenirken bir hata oluştu: $e';
      notifyListeners();
    }
  }

  // Barkod ile ürün ara
  Future<void> searchByBarcode(String barcode) async {
    _setLoading(true);
    try {
      final productData = await _barcodeService.getProductByBarcode(barcode);
      if (productData != null) {
        _currentProduct = ProductModel.fromJson(productData);
        _error = null;
      } else {
        _currentProduct = null;
        _error = 'Ürün bulunamadı';
      }
    } catch (e) {
      _error = 'Ürün arama hatası: $e';
      _currentProduct = null;
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initLocation() async {
    _setLoading(true);
    try {
      _currentLocation = await _locationService.getCurrentLocation();
      if (_currentLocation != null) {
        // Konum alındıktan sonra en yakın marketleri getir
        await _fetchNearbyMarkets();
      }
    } catch (e) {
      _error = 'Konum alınamadı: $e';
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<void> _fetchNearbyMarkets() async {
    try {
      // TODO: Firebase'den yakındaki marketleri çek
      _error = null;
    } catch (e) {
      _error = 'Marketler yüklenirken hata oluştu: $e';
    }
    notifyListeners();
  }
}
