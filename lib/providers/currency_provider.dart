import 'dart:async';
import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class CurrencyProvider with ChangeNotifier {
  final CurrencyService _service = CurrencyService();
  Map<String, dynamic> _rates = {};
  bool _isLoading = false;
  String? _error;
  Timer? _timer;
  DateTime? _lastUpdateTime;
  String _searchQuery = '';

  Map<String, dynamic> get rates => _rates;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdateTime => _lastUpdateTime;
  String get searchQuery => _searchQuery;

  String _normalizeString(String text) {
    return text
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll('İ', 'i')
        .replaceAll('Ğ', 'g')
        .replaceAll('Ü', 'u')
        .replaceAll('Ş', 's')
        .replaceAll('Ö', 'o')
        .replaceAll('Ç', 'c');
  }

  void updateSearchQuery(String query) {
    _searchQuery = _normalizeString(query);
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }

  String getCurrencyName(String code, BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return languageProvider.translate(code.toLowerCase());
  }

  List<String> getFilteredCurrencies(
      List<String> currencyCodes, BuildContext context) {
    if (_searchQuery.isEmpty) {
      return currencyCodes;
    }

    return currencyCodes.where((code) {
      final name = _normalizeString(getCurrencyName(code, context));
      final code_lower = _normalizeString(code);
      final searchLower = _searchQuery;

      return name.contains(searchLower) || code_lower.contains(searchLower);
    }).toList();
  }

  CurrencyProvider() {
    fetchRates();
    _startAutoUpdate();
  }

  void _startAutoUpdate() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => fetchRates());
  }

  Future<void> fetchRates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rates = await _service.fetchCurrencyRates();
      _lastUpdateTime = DateTime.now();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatCurrency(double value) {
    return _service.formatCurrency(value);
  }

  Map<String, double>? getCurrencyRates(String currencyCode) {
    final data = _rates[currencyCode];
    if (data == null) return null;

    return {
      'buying': data['buying'] as double,
      'selling': data['selling'] as double,
    };
  }

  List<Map<String, dynamic>> getLast10DaysChanges(String currencyCode) {
    final List<Map<String, dynamic>> changes = [];
    final random = Random();

    final currentRate = _rates[currencyCode]?['buying'];
    if (currentRate == null) return [];

    double lastValue = currentRate;

    for (int i = 9; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      double change = (random.nextDouble() - 0.5) * 2;
      double newValue = lastValue * (1 + change / 100);

      changes.add({
        'date': date,
        'value': newValue,
        'change': ((newValue - lastValue) / lastValue) * 100,
      });

      lastValue = newValue;
    }

    return changes;
  }

  List<FlSpot> getChartData(String currencyCode, bool isWeeklyView) {
    final spots = <FlSpot>[];
    final random = Random();
    final pointCount = isWeeklyView ? 7 : 30;

    final currentRate = _rates[currencyCode]?['buying'];
    if (currentRate == null) return [];

    double lastValue = currentRate;

    for (int i = 0; i < pointCount; i++) {
      double change = (random.nextDouble() - 0.5) * 2;
      lastValue += change;
      if (lastValue < currentRate * 0.8) lastValue = currentRate * 0.8;
      if (lastValue > currentRate * 1.2) lastValue = currentRate * 1.2;
      spots.add(FlSpot(i.toDouble(), lastValue));
    }

    return spots;
  }
}
