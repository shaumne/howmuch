import 'package:flutter/material.dart';
import '../../catalog/models/catalog_model.dart';
import 'package:intl/intl.dart';

class CatalogApprovalCard extends StatelessWidget {
  final CatalogModel catalog;
  final Function() onApprove;
  final Function(String) onReject;
  final Function() onDelete;

  const CatalogApprovalCard({
    Key? key,
    required this.catalog,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy');
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catalog.marketId == 'sok' ? 'ŞOK Market' : 'Market',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '${dateFormat.format(catalog.startDate)} - ${dateFormat.format(catalog.endDate)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(
              catalog.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error_outline, size: 50, color: Colors.red),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!catalog.isApproved) ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Onayla'),
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Reddet'),
                    onPressed: () => _showRejectDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.red,
                  onPressed: () => _showDeleteDialog(context),
                  tooltip: 'Kataloğu Sil',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reddetme Nedeni'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Reddetme nedenini yazın',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onReject(controller.text);
            },
            child: const Text('Reddet'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Katalog Silinecek'),
        content: const Text('Bu kataloğu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
} 