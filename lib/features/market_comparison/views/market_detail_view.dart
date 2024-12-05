import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketDetailView extends StatelessWidget {
  final Map<String, dynamic> market;

  const MarketDetailView({Key? key, required this.market}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(market['name'])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Market Bilgileri', style: theme.textTheme.titleLarge),
                    Divider(),
                    ListTile(
                      leading: Text(
                        market['logo']!,
                        style: TextStyle(fontSize: 24),
                      ),
                      title: Text(market['name']!),
                      subtitle: Text('Durum: ${market['status']}'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Güncel İndirimler',
                      style: theme.textTheme.titleLarge,
                    ),
                    Divider(),
                    _buildDiscountList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchMarketWebsite(market['name']),
              icon: Icon(Icons.public),
              label: Text('Web Sitesini Ziyaret Et'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountList() {
    final discounts = [
      {'product': 'Süt', 'discount': '%20'},
      {'product': 'Ekmek', 'discount': '%15'},
      {'product': 'Yoğurt', 'discount': '%25'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        final discount = discounts[index];
        return ListTile(
          title: Text(discount['product']!),
          trailing: Text(
            discount['discount']!,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Future<void> _launchMarketWebsite(String marketName) async {
    final Map<String, String> marketUrls = {
      'A101': 'https://www.a101.com.tr',
      'BİM': 'https://www.bim.com.tr',
      'ŞOK': 'https://www.sokmarket.com.tr',
      'Migros': 'https://www.migros.com.tr',
      'CarrefourSA': 'https://www.carrefoursa.com',
    };

    final url = Uri.parse(marketUrls[marketName] ?? '');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
