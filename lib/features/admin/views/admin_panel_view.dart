import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import 'pending_catalogs_view.dart';
import 'approved_catalogs_view.dart';

class AdminPanelView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    if (!isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text('Bu sayfaya erişim yetkiniz yok'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminCard(
            context,
            title: 'Onay Bekleyen Kataloglar',
            icon: Icons.pending_actions,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingCatalogsView(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildAdminCard(
            context,
            title: 'Onaylanmış Kataloglar',
            icon: Icons.check_circle_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApprovedCatalogsView(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildAdminCard(
            context,
            title: 'Market Yönetimi',
            icon: Icons.store,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Yakında eklenecek')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
} 