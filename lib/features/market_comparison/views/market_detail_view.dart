import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import 'package:intl/intl.dart';
import '../../../models/catalog_model.dart';
import '../../../services/catalog_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarketDetailView extends StatelessWidget {
  final Map<String, dynamic> market;

  const MarketDetailView({super.key, required this.market});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.primaryContainer.withAlpha(204),
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    market['logo']!,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            title: Text(market['name']!),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Market Bilgileri
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Market Bilgileri',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(
                              market['status'] == 'Açık'
                                  ? Icons.check_circle
                                  : Icons.close,
                              color:
                                  market['status'] == 'Açık'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                            title: Text(market['name']!),
                            subtitle: Text('Durum: ${market['status']}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // A101 için katalog gösterimi
                  if (market['id'] == 'a101')
                    StreamBuilder<DocumentSnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('catalogs')
                              .doc('a101')
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Hata: ${snapshot.error}'));
                        }

                        final data =
                            snapshot.data?.data() as Map<String, dynamic>?;
                        final imageUrl = data?['imageUrl'] as String?;
                        final lastUpdated = data?['lastUpdated'] as Timestamp?;

                        if (imageUrl == null || imageUrl.isEmpty) {
                          return const Center(
                            child: Text('Katalog bulunamadı'),
                          );
                        }

                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Güncel Katalog',
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ),
                                    if (lastUpdated != null)
                                      Flexible(
                                        child: Text(
                                          'Son güncelleme: ${DateFormat('dd/MM/yyyy').format(lastUpdated.toDate())}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: Image.network(
                                  imageUrl.trim(),
                                  fit: BoxFit.contain,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Resim yükleme hatası: $error');
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text('Katalog yüklenemedi'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),
                  // Web sitesi butonu
                  ElevatedButton.icon(
                    onPressed: () => _launchMarketWebsite(market['website']),
                    icon: const Icon(Icons.public),
                    label: const Text('Web Sitesini Ziyaret Et'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchMarketWebsite(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
