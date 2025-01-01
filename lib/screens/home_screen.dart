import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/currency_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/language_provider.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import '../screens/currency_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      systemNavigationBarIconBrightness:
          isDarkMode ? Brightness.light : Brightness.dark,
    ));

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMainContent(),
                const NotificationsScreen(),
                const SettingsScreen(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              unselectedLabelColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
              indicatorColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              tabs: [
                Tab(
                  icon: const Icon(Icons.currency_exchange),
                  text: languageProvider.translate('exchange_rates'),
                ),
                Tab(
                  icon: const Icon(Icons.notifications),
                  text: languageProvider.translate('notifications'),
                ),
                Tab(
                  icon: const Icon(Icons.settings),
                  text: languageProvider.translate('settings'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSearchModal(BuildContext context) {
    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E1E1E)
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Consumer<CurrencyProvider>(
                    builder: (context, provider, child) => TextField(
                      autofocus: true,
                      onChanged: provider.updateSearchQuery,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: languageProvider.translate('search'),
                        hintStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<CurrencyProvider>(
                    builder: (context, provider, child) {
                      final allCurrencies = provider.getFilteredCurrencies([
                        'USD',
                        'EUR',
                        'GBP',
                        'JPY',
                        'KWD',
                        'MXN',
                        'CAD',
                        'AUD',
                        'CHF',
                        'CNY',
                        'SEK',
                        'NOK',
                        'DKK',
                        'RUB',
                        'INR',
                        'SAR',
                        'GOLD',
                        'XAU'
                      ], context);

                      if (allCurrencies.isEmpty) {
                        return Center(
                          child: Text(
                            languageProvider.translate('no_results'),
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: allCurrencies.length,
                        itemBuilder: (context, index) {
                          final code = allCurrencies[index];
                          final rates = provider.getCurrencyRates(code);
                          if (rates == null) return const SizedBox.shrink();

                          return ListTile(
                            title: Text(
                              provider.getCurrencyName(code, context),
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              code,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${languageProvider.translate('buying')}: ${provider.formatCurrency(rates['buying']!)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                                Text(
                                  '${languageProvider.translate('selling')}: ${provider.formatCurrency(rates['selling']!)}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).then((_) => provider.clearSearchQuery());
  }

  Widget _buildMainContent() {
    return Consumer2<CurrencyProvider, LanguageProvider>(
      builder: (context, provider, languageProvider, child) {
        if (provider.isLoading) {
          return const Center(
            child: SpinKitFadingCircle(
              color: Colors.blue,
              size: 50.0,
            ),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.fetchRates(),
                  icon: const Icon(Icons.refresh),
                  label: Text(languageProvider.translate('refresh')),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchRates(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E1E1E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _showSearchModal(context),
                      icon: Icon(
                        Icons.search,
                        size: 28,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    Text(
                      languageProvider.translate('search'),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    Consumer<NotificationProvider>(
                      builder: (context, notificationProvider, child) {
                        final unreadCount = notificationProvider.unreadCount;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              onPressed: () => _tabController.animateTo(1),
                              icon: Icon(
                                Icons.notifications_outlined,
                                size: 28,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                right: -5,
                                top: -5,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(child: _buildLastUpdateInfo(context)),
              const SizedBox(height: 16),
              _buildCurrencyCard(
                context,
                languageProvider.translate('exchange_rates'),
                provider.getFilteredCurrencies([
                  'USD',
                  'EUR',
                  'GBP',
                  'JPY',
                  'KWD',
                  'MXN',
                  'CAD',
                  'AUD',
                  'CHF',
                  'CNY',
                  'SEK',
                  'NOK',
                  'DKK',
                  'RUB',
                  'INR',
                  'SAR'
                ], context),
                provider,
                Icons.currency_exchange,
              ),
              const SizedBox(height: 16),
              _buildCurrencyCard(
                context,
                languageProvider.translate('gold_prices'),
                provider.getFilteredCurrencies(['GOLD', 'XAU'], context),
                provider,
                Icons.monetization_on,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLastUpdateInfo(BuildContext context) {
    return Consumer2<CurrencyProvider, LanguageProvider>(
      builder: (context, provider, languageProvider, child) {
        final lastUpdate = provider.lastUpdateTime;

        if (lastUpdate == null) {
          return Text(
            languageProvider.translate('updating'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          );
        }

        final months = [
          languageProvider.translate('jan'),
          languageProvider.translate('feb'),
          languageProvider.translate('mar'),
          languageProvider.translate('apr'),
          languageProvider.translate('may'),
          languageProvider.translate('jun'),
          languageProvider.translate('jul'),
          languageProvider.translate('aug'),
          languageProvider.translate('sep'),
          languageProvider.translate('oct'),
          languageProvider.translate('nov'),
          languageProvider.translate('dec'),
        ];

        String formattedTime =
            '${lastUpdate.day.toString().padLeft(2, '0')} ${months[lastUpdate.month - 1]} ${lastUpdate.year} ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}:${lastUpdate.second.toString().padLeft(2, '0')}';

        return Text(
          '${languageProvider.translate('last_update')}: $formattedTime',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  Widget _buildCurrencyCard(BuildContext context, String title,
      List<String> currencyCodes, CurrencyProvider provider, IconData icon) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                ...currencyCodes.map((code) {
                  final rates = provider.getCurrencyRates(code);

                  if (rates == null) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrencyDetailScreen(
                              currencyCode: code,
                              currencyName:
                                  provider.getCurrencyName(code, context),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.getCurrencyName(code, context),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                code == 'GOLD' ? '(GAU/TL)' : '($code/TL)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildRateRow(
                                languageProvider.translate('buying'),
                                provider.formatCurrency(rates['buying']!),
                                Colors.green,
                              ),
                              const SizedBox(height: 4),
                              _buildRateRow(
                                languageProvider.translate('selling'),
                                provider.formatCurrency(rates['selling']!),
                                Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRateRow(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
