import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import 'pending_catalogs_view.dart';

class AdminPanelView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    if (!isAdmin) {
      return Scaffold(
        body: Center(
          child: Text('Bu sayfaya erişim yetkiniz yok'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildAdminCard(
            context,
            title: 'Katalog Onayları',
            icon: Icons.approval,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingCatalogsView(),
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildAdminCard(
            context,
            title: 'Market Yönetimi',
            icon: Icons.store,
            onTap: () {
              // Market yönetimi sayfasına yönlendirme
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Yakında eklenecek')),
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