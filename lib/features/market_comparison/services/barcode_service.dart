import 'package:cloud_firestore/cloud_firestore.dart';

class BarcodeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getProductByBarcode(String barcode) async {
    try {
      final doc = await _firestore.collection('products').doc(barcode).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Barkod sorgulama hatası: $e');
      return null;
    }
  }

  Future<void> addProduct(
    String barcode,
    Map<String, dynamic> productData,
  ) async {
    try {
      await _firestore.collection('products').doc(barcode).set({
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Ürün ekleme hatası: $e');
      rethrow;
    }
  }
}
