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
    try {
      // Statik market listesini kullan
      _markets = _fetchNearbyMarkets();
      _error = null;
    } catch (e) {
      _error = 'Market verilerini alırken bir hata oluştu: $e';
      print(_error);
    }
    _setLoading(false);
    notifyListeners();
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

  bool isMarketOpen(TimeOfDay openTime, TimeOfDay closeTime) {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final openMinutes = openTime.hour * 60 + openTime.minute;
    final closeMinutes = closeTime.hour * 60 + closeTime.minute;

    return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
  }

  List<MarketModel> _fetchNearbyMarkets() {
    return [
      MarketModel(
        id: 'bim',
        name: 'BİM',
        logo: 'assets/images/markets/bim_logo.png',
        status:
            isMarketOpen(
                  const TimeOfDay(hour: 9, minute: 0),
                  const TimeOfDay(hour: 21, minute: 30),
                )
                ? 'Açık'
                : 'Kapalı',
        distance: '',
        address: '',
        rating: 0,
        website: 'https://www.bim.com.tr',
        categories: ['Market'],
        lastUpdated: DateTime.now(),
      ),
      // ... diğer marketler
    ];
  }
}
