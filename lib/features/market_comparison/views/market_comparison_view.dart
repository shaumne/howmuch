import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../authentication/providers/auth_provider.dart' as app_auth;
import '../providers/market_provider.dart';
import '../models/market_model.dart';
import 'barcode_scanner_view.dart';
import 'market_detail_view.dart';

class MarketComparisonView extends StatefulWidget {
  const MarketComparisonView({super.key});

  @override
  State<MarketComparisonView> createState() => _MarketComparisonViewState();
}

class _MarketComparisonViewState extends State<MarketComparisonView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketProvider>().initMarkets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<app_auth.AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Marketler'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _navigateToNotifications(context),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => _navigateToSettings(context),
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildSearchBar(theme),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(
                    authProvider.user?.displayName ?? 'Kullanıcı',
                    theme,
                  ),
                  const SizedBox(height: 24),
                  _buildMarketsSection(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      controller: _searchController,
      enabled: false,
      decoration: InputDecoration(
        hintText: 'Yakında aktif olacak',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: null,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.5),
      ),
    );
  }

  Widget _buildWelcomeSection(String username, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merhaba $username',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tek tıkla kampanya takip etmeye hazır mısın?',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketsSection(ThemeData theme) {
    final now = TimeOfDay.now();

    bool isMarketOpen(TimeOfDay opening, TimeOfDay closing) {
      final currentMinutes = now.hour * 60 + now.minute;
      final openingMinutes = opening.hour * 60 + opening.minute;
      final closingMinutes = closing.hour * 60 + closing.minute;

      return currentMinutes >= openingMinutes &&
          currentMinutes <= closingMinutes;
    }

    final markets = [
      MarketModel(
        id: 'bim',
        name: 'BİM',
        logo: 'assets/images/markets/bim_logo.png',
        status:
            isMarketOpen(
                  const TimeOfDay(hour: 9, minute: 0),
                  const TimeOfDay(hour: 21, minute: 30),
                )
                ? 'Açık'
                : 'Kapalı',
        distance: '',
        address: '',
        rating: 0,
        website: 'https://www.bim.com.tr',
        categories: ['Market'],
        lastUpdated: DateTime.now(),
      ),
      MarketModel(
        id: 'a101',
        name: 'A101',
        logo: 'assets/images/markets/a101_logo.png',
        status:
            isMarketOpen(
                  const TimeOfDay(hour: 9, minute: 0),
                  const TimeOfDay(hour: 21, minute: 30),
                )
                ? 'Açık'
                : 'Kapalı',
        distance: '',
        address: '',
        rating: 0,
        website: 'https://www.a101.com.tr',
        categories: ['Market'],
        lastUpdated: DateTime.now(),
      ),
      MarketModel(
        id: 'sok',
        name: 'ŞOK',
        logo: 'assets/images/markets/sok_logo.png',
        status:
            isMarketOpen(
                  const TimeOfDay(hour: 9, minute: 0),
                  const TimeOfDay(hour: 21, minute: 30),
                )
                ? 'Açık'
                : 'Kapalı',
        distance: '',
        address: '',
        rating: 0,
        website: 'https://www.sokmarket.com.tr',
        categories: ['Market'],
        lastUpdated: DateTime.now(),
      ),
      MarketModel(
        id: 'carrefoursa',
        name: 'CarrefourSA',
        logo: 'assets/images/markets/carrefoursa_logo.png',
        status:
            isMarketOpen(
                  const TimeOfDay(hour: 9, minute: 0),
                  const TimeOfDay(hour: 22, minute: 0),
                )
                ? 'Açık'
                : 'Kapalı',
        distance: '',
        address: '',
        rating: 0,
        website: 'https://www.carrefoursa.com',
        categories: ['Market'],
        lastUpdated: DateTime.now(),
      ),
      MarketModel(
        id: 'migros',
        name: 'Migros',
        logo: 'assets/images/markets/migros_logo.png',
        status:
            isMarketOpen(
                  const TimeOfDay(hour: 9, minute: 0),
                  const TimeOfDay(hour: 22, minute: 0),
                )
                ? 'Açık'
                : 'Kapalı',
        distance: '',
        address: '',
        rating: 0,
        website: 'https://www.migros.com.tr',
        categories: ['Market'],
        lastUpdated: DateTime.now(),
      ),
    ];

    if (context.watch<MarketProvider>().isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (context.watch<MarketProvider>().error != null) {
      return Center(child: Text(context.watch<MarketProvider>().error!));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Yakınındaki Marketler',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showAllMarkets(context),
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: markets.length,
            itemBuilder: (context, index) {
              final market = markets[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index != markets.length - 1 ? 16.0 : 0,
                ),
                child: GestureDetector(
                  onTap: () => _navigateToMarketDetail(context, market),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(market.logo),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      market.status == 'Açık'
                                          ? Colors.green
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  market.status,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                market.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                market.distance,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToMarketDetail(BuildContext context, MarketModel market) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketDetailView(market: market.toJson()),
      ),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bildirimler yakında eklenecek')),
    );
  }

  void _navigateToSettings(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ayarlar yakında eklenecek')));
  }

  void _showAllMarkets(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tüm marketler yakında listelenecek')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
