import 'package:flutter/material.dart';
import '../../catalog/services/catalog_service.dart';
import '../../catalog/models/catalog_model.dart';
import '../widgets/catalog_approval_card.dart';

class ApprovedCatalogsView extends StatelessWidget {
  final CatalogService _catalogService = CatalogService();

  // Market isimlerini getiren yardımcı metod
  String _getMarketName(String marketId) {
    switch (marketId) {
      case 'sok':
        return 'ŞOK Market';
      case 'bim':
        return 'BİM';
      case 'a101':
        return 'A101';
      case 'carrefoursa':
        return 'CarrefourSA';
      case 'migros':
        return 'Migros';
      default:
        return 'Diğer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Market sayısını 5'e çıkardık
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Onaylanmış Kataloglar'),
          bottom: const TabBar(
            isScrollable: true, // Tablar scrollable olsun
            tabs: [
              Tab(text: 'ŞOK'),
              Tab(text: 'BİM'),
              Tab(text: 'A101'),
              Tab(text: 'CarrefourSA'),
              Tab(text: 'Migros'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMarketCatalogs('sok'),
            _buildMarketCatalogs('bim'),
            _buildMarketCatalogs('a101'),
            _buildMarketCatalogs('carrefoursa'),
            _buildMarketCatalogs('migros'),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketCatalogs(String marketId) {
    return StreamBuilder<List<CatalogModel>>(
      stream: _catalogService.getApprovedCatalogsByMarket(marketId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final catalogs = snapshot.data ?? [];

        if (catalogs.isEmpty) {
          return Center(
            child: Text('${_getMarketName(marketId)} için onaylanmış katalog bulunmuyor'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: catalogs.length,
          itemBuilder: (context, index) {
            final catalog = catalogs[index];
            return CatalogApprovalCard(
              catalog: catalog,
              onApprove: () {}, // Zaten onaylı
              onReject: (_) {}, // Zaten onaylı
              onDelete: () async {
                try {
                  await _catalogService.deleteCatalog(catalog.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Katalog başarıyla silindi')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Silme hatası: $e')),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
} 