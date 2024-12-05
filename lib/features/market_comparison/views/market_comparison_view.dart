import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../authentication/providers/auth_provider.dart';
import '../providers/market_provider.dart';
import 'barcode_scanner_view.dart';
import 'market_detail_view.dart';

class MarketComparisonView extends StatefulWidget {
  @override
  _MarketComparisonViewState createState() => _MarketComparisonViewState();
}

class _MarketComparisonViewState extends State<MarketComparisonView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.priceComparison),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
          CircleAvatar(
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null ? Icon(Icons.person) : null,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hello(user?.displayName ?? 'Kullanıcı'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                l10n.readyToFind,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceVariant,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: l10n.searchHint,
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner,
                            color: theme.colorScheme.onPrimary,
                          ),
                          onPressed: _scanBarcode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                l10n.markets,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildMarketList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
        },
        icon: Icon(Icons.add),
        label: Text(l10n.addNewProduct),
        elevation: 4,
      ),
    );
  }

  Future<void> _scanBarcode() async {
    setState(() => _isScanning = true);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerView()),
    );

    if (result != null) {
      _searchController.text = result;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.scanBarcode(result))));
    }

    setState(() => _isScanning = false);
  }

  Widget _buildMarketList() {
    final markets = context.watch<MarketProvider>().markets;
    final l10n = AppLocalizations.of(context)!;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: markets.length,
      itemBuilder: (context, index) {
        final market = markets[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Text(market['logo']!, style: TextStyle(fontSize: 24)),
            title: Text(market['name']!),
            subtitle: Text(
              l10n.status(market['status'] == 'Açık' ? l10n.open : l10n.closed),
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => _navigateToMarketDetail(market),
            ),
          ),
        );
      },
    );
  }

  void _navigateToMarketDetail(Map<String, dynamic> market) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MarketDetailView(market: market)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
