import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';

class CurrencyService {
  static const String _baseUrl = 'https://www.tcmb.gov.tr/kurlar/today.xml';

  Future<Map<String, dynamic>> fetchCurrencyRates() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return _parseXmlResponse(response.body);
      } else {
        throw Exception('status_code_error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('data_error: $e');
    }
  }

  Map<String, dynamic> _parseXmlResponse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      final currencies = document.findAllElements('Currency');
      Map<String, dynamic> result = {};

      for (var currency in currencies) {
        final code = currency.getAttribute('CurrencyCode');
        if (code != null && code != 'XAU') {
          final buying = double.tryParse(
                  currency.findElements('ForexBuying').firstOrNull?.text ??
                      '0') ??
              0.0;
          final selling = double.tryParse(
                  currency.findElements('ForexSelling').firstOrNull?.text ??
                      '0') ??
              0.0;

          result[code] = {
            'buying': buying,
            'selling': selling,
          };
        }
      }

      final usdRate = result['USD']?['buying'] ?? 0.0;
      final goldCurrency = currencies.firstWhere(
          (element) => element.getAttribute('CurrencyCode') == 'XAU',
          orElse: () => currencies.first);

      if (goldCurrency.getAttribute('CurrencyCode') == 'XAU') {
        final goldUsdBuying = double.tryParse(
                goldCurrency.findElements('ForexBuying').firstOrNull?.text ??
                    '0') ??
            0.0;
        final goldUsdSelling = double.tryParse(
                goldCurrency.findElements('ForexSelling').firstOrNull?.text ??
                    '0') ??
            0.0;

        final goldTryBuying = goldUsdBuying * usdRate;
        final goldTrySelling = goldUsdSelling * usdRate;

        result['XAU'] = {
          'buying': goldTryBuying,
          'selling': goldTrySelling,
        };

        result['GOLD'] = {
          'buying': goldTryBuying / 31.1,
          'selling': goldTrySelling / 31.1,
        };
      }

      return result;
    } catch (e) {
      throw Exception('xml_parse_error: $e');
    }
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }
}
