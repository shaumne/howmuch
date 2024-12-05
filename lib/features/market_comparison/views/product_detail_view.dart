import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null)
              Center(
                child: Image.network(
                  product.imageUrl!,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 16),
            Text('Ürün Detayları', style: theme.textTheme.titleLarge),
            Divider(),
            ListTile(title: Text('Barkod'), subtitle: Text(product.barcode)),
            ListTile(title: Text('Kategori'), subtitle: Text(product.category)),
            ListTile(
              title: Text('Açıklama'),
              subtitle: Text(product.description),
            ),
            SizedBox(height: 16),
            Text('Market Fiyatları', style: theme.textTheme.titleLarge),
            Divider(),
            ...product.prices.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: Text(
                  '${entry.value.toStringAsFixed(2)} ₺',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
