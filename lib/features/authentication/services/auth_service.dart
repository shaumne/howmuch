import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<UserModel?> signInWithGoogle() async {
    try {
      // Mevcut oturumları temizle
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Google Sign In işlemini başlat
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Google Sign In iptal edildi');
        return null;
      }

      try {
        // Google kimlik bilgilerini al
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Firebase kimlik bilgilerini oluştur
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase ile giriş yap
        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        final User? user = userCredential.user;

        if (user != null) {
          print('Google Sign In başarılı: ${user.email}');
          // UserModel oluştur
          return UserModel(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? '',
            photoURL: user.photoURL,
          );
        }
      } on FirebaseAuthException catch (e) {
        print('Firebase Auth Hatası: ${e.code} - ${e.message}');
        if (e.code == 'account-exists-with-different-credential') {
          print(
            'Bu email adresi başka bir giriş yöntemi ile ilişkilendirilmiş',
          );
        }
        return null;
      }
    } catch (e) {
      print('Google Sign-In Hatası: $e');
      return null;
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
      );
    }
    return null;
  }
}
