import 'dart:async';
import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';

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

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
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

  List<String> getFilteredCurrencies(List<String> currencyCodes) {
    if (_searchQuery.isEmpty) {
      return currencyCodes;
    }

    return currencyCodes.where((code) {
      final name = code.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return name.contains(searchLower);
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
}
