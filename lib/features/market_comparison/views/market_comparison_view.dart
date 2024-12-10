import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../authentication/providers/auth_provider.dart' as app_auth;
import '../providers/market_provider.dart';
import '../models/market_model.dart';
import 'barcode_scanner_view.dart';
import 'market_detail_view.dart';
import 'dart:ui';

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
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar
          SliverAppBar.large(
            stretch: true,
            expandedHeight: 180,
            backgroundColor: theme.colorScheme.primary,
            title: const Text(
              'How Much',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
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
              preferredSize: const Size.fromHeight(90),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: _buildSearchBar(theme),
              ),
            ),
          ),

          // Ana İçerik
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildWelcomeSection(
                    authProvider.user?.displayName ?? 'Kullanıcı',
                    theme,
                  ),
                  const SizedBox(height: 32),
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
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            enabled: false,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ürün veya market ara',
                              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.5,
                                ),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: null,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                    child: Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(String username, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merhaba $username 👋',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tek tıkla kampanya takip etmeye hazır mısın?',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
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
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Yakınındaki Marketler',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAllMarkets(context),
              icon: const Icon(Icons.storefront),
              label: const Text('Tümünü Gör'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
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
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Logo Bölümü
                        SizedBox(
                          height: 140,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.colorScheme.surface,
                                      Colors.white,
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Hero(
                                  tag: 'market-${market.id}',
                                  child: Image.asset(
                                    market.logo,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // Durum İndikatörü
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        market.status == 'Açık'
                                            ? Colors.green.withOpacity(0.9)
                                            : Colors.red.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        market.status,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bilgi Bölümü
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Market Adı
                                Text(
                                  market.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Kampanya Göstergesi
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_offer_outlined,
                                        size: 14,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Aktif Kampanyalar',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // Detay Butonu
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Detayları Gör',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
