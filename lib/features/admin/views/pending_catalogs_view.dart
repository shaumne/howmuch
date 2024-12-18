import 'package:flutter/material.dart';
import '../../catalog/services/catalog_service.dart';
import '../../catalog/models/catalog_model.dart';
import '../widgets/catalog_approval_card.dart';

class PendingCatalogsView extends StatelessWidget {
  final CatalogService _catalogService = CatalogService();

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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Onay Bekleyen Kataloglar'),
          bottom: const TabBar(
            isScrollable: true,
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
            _buildMarketCatalogs('sok', context),
            _buildMarketCatalogs('bim', context),
            _buildMarketCatalogs('a101', context),
            _buildMarketCatalogs('carrefoursa', context),
            _buildMarketCatalogs('migros', context),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketCatalogs(String marketId, BuildContext context) {
    return StreamBuilder<List<CatalogModel>>(
      stream: _catalogService.getPendingCatalogsByMarket(marketId),
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
            child: Text('${_getMarketName(marketId)} için onay bekleyen katalog bulunmuyor'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: catalogs.length,
          itemBuilder: (context, index) {
            final catalog = catalogs[index];
            return CatalogApprovalCard(
              catalog: catalog,
              onApprove: () => _approveCatalog(context, catalog.id),
              onReject: (reason) => _rejectCatalog(context, catalog.id, reason),
              onDelete: () => _deleteCatalog(context, catalog.id),
            );
          },
        );
      },
    );
  }

  Future<void> _approveCatalog(BuildContext context, String catalogId) async {
    try {
      await _catalogService.approveCatalog(catalogId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Katalog başarıyla onaylandı')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Onaylama hatası: $e')),
      );
    }
  }

  Future<void> _rejectCatalog(BuildContext context, String catalogId, String reason) async {
    try {
      await _catalogService.rejectCatalog(catalogId, reason);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Katalog reddedildi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reddetme hatası: $e')),
      );
    }
  }

  Future<void> _deleteCatalog(BuildContext context, String catalogId) async {
    try {
      await _catalogService.deleteCatalog(catalogId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Katalog başarıyla silindi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme hatası: $e')),
      );
    }
  }
} 