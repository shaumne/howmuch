import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<bool> isAdmin(String uid) async {
    try {
      final doc = await _firestore.collection('admins').doc(uid).get();
      return doc.exists && doc.data()?['isAdmin'] == true;
    } catch (e) {
      print('Admin kontrolü hatası: $e');
      return false;
    }
  }
} 