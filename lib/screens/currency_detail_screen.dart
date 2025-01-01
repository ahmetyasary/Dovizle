import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'dart:math';

class CurrencyDetailScreen extends StatefulWidget {
  final String currencyCode;
  final String currencyName;

  const CurrencyDetailScreen({
    Key? key,
    required this.currencyCode,
    required this.currencyName,
  }) : super(key: key);

  @override
  State<CurrencyDetailScreen> createState() => _CurrencyDetailScreenState();
}

class _CurrencyDetailScreenState extends State<CurrencyDetailScreen> {
  bool isWeeklyView = true;
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    final random = Random();
    spots = [];
    final int pointCount = isWeeklyView ? 7 : 30;
    double lastValue = 20 + random.nextDouble() * 10;

    for (int i = 0; i < pointCount; i++) {
      double change = (random.nextDouble() - 0.5) * 2;
      lastValue += change;
      if (lastValue < 15) lastValue = 15;
      if (lastValue > 35) lastValue = 35;
      spots.add(FlSpot(i.toDouble(), lastValue));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.currencyName} (${widget.currencyCode})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(languageProvider.translate('weekly')),
                  selected: isWeeklyView,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        isWeeklyView = true;
                        _generateData();
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: Text(languageProvider.translate('monthly')),
                  selected: !isWeeklyView,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        isWeeklyView = false;
                        _generateData();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 == 0) {
                            final int day = value.toInt() + 1;
                            return Text(day.toString());
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
