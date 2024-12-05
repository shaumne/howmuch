import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../market_comparison/views/market_comparison_view.dart';

class RegisterView extends StatelessWidget {
  void _handleGoogleSignUp(BuildContext context) async {
    try {
      final userModel = await context.read<AuthProvider>().signInWithGoogle();

      if (userModel != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google ile kayıt başarılı')));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MarketComparisonView()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt sırasında bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.secondaryContainer,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo veya uygulama adı
                  Icon(
                    Icons.person_add_outlined,
                    size: 80,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Yeni Hesap Oluştur',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fiyat karşılaştırmaya hemen başla',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Google ile kayıt butonu
                  FilledButton.icon(
                    onPressed: () => _handleGoogleSignUp(context),
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 56),
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24,
                    ),
                    label: Text(
                      'Google ile Kaydol',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Giriş yap linki
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Zaten hesabın var mı? Giriş yap',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
