import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../catalog/models/catalog_model.dart';
import '../../catalog/services/catalog_service.dart';
import '../services/admin_service.dart';

class PendingCatalogsView extends StatelessWidget {
  final CatalogService _catalogService = CatalogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onay Bekleyen Kataloglar'),
      ),
      body: StreamBuilder<List<CatalogModel>>(
        stream: _catalogService.getPendingCatalogs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final catalogs = snapshot.data ?? [];

          if (catalogs.isEmpty) {
            return Center(child: Text('Onay bekleyen katalog yok'));
          }

          return ListView.builder(
            itemCount: catalogs.length,
            itemBuilder: (context, index) {
              final catalog = catalogs[index];
              return CatalogApprovalCard(catalog: catalog);
            },
          );
        },
      ),
    );
  }
}

class CatalogApprovalCard extends StatelessWidget {
  final CatalogModel catalog;
  final CatalogService _catalogService = CatalogService();

  CatalogApprovalCard({required this.catalog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.network(
            catalog.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Market ID: ${catalog.marketId}'),
                Text('Başlangıç: ${DateFormat('dd/MM/yyyy').format(catalog.startDate)}'),
                Text('Bitiş: ${DateFormat('dd/MM/yyyy').format(catalog.endDate)}'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text('Onayla'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => _approveCatalog(context),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.close),
                      label: Text('Reddet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => _showRejectDialog(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _approveCatalog(BuildContext context) async {
    try {
      await _catalogService.approveCatalog(catalog.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Katalog onaylandı')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  Future<void> _showRejectDialog(BuildContext context) async {
    String reason = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reddetme Nedeni'),
        content: TextField(
          onChanged: (value) => reason = value,
          decoration: InputDecoration(
            hintText: 'Reddetme nedenini yazın',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              if (reason.isNotEmpty) {
                Navigator.pop(context);
                try {
                  await _catalogService.rejectCatalog(catalog.id, reason);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Katalog reddedildi')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hata oluştu: $e')),
                  );
                }
              }
            },
            child: Text('Reddet'),
          ),
        ],
      ),
    );
  }
} 