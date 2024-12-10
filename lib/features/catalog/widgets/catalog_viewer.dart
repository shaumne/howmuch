import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/catalog_model.dart';

class CatalogViewer extends StatelessWidget {
  final Catalog catalog;

  const CatalogViewer({Key? key, required this.catalog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(catalog.marketName.toUpperCase()),
          Image.network(
            catalog.imageUrl,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
          Text(
            'Son Güncelleme: ${DateFormat('dd/MM/yyyy HH:mm').format(catalog.lastUpdated)}',
          ),
        ],
      ),
    );
  }
}
