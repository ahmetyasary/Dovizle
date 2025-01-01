import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>>? last10DaysChanges;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _generateData();
      _isInitialized = true;
    }
  }

  void _generateData() {
    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    if (provider.rates.isEmpty || provider.rates[widget.currencyCode] == null) {
      return;
    }

    last10DaysChanges = provider.getLast10DaysChanges(widget.currencyCode);
    spots = provider.getChartData(widget.currencyCode, isWeeklyView);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (currencyProvider.rates.isEmpty ||
        currencyProvider.rates[widget.currencyCode] == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.currencyName} (${widget.currencyCode})'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                languageProvider.translate('loading'),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.currencyName} (${widget.currencyCode})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.translate('buying'),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyProvider.formatCurrency(
                          currencyProvider.rates[widget.currencyCode]['buying'],
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        languageProvider.translate('selling'),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyProvider.formatCurrency(
                          currencyProvider.rates[widget.currencyCode]
                              ['selling'],
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                        getTitlesWidget: (value, meta) {
                          return Text(
                            NumberFormat("0.00", "tr_TR").format(value),
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 == 0) {
                            final int day = value.toInt() + 1;
                            return Text(
                              day.toString(),
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                                fontSize: 12,
                              ),
                            );
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
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor:
                                isDarkMode ? Colors.white : Colors.black,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchSpotThreshold: 10,
                    getTouchLineEnd: (_, __) => double.infinity,
                    getTouchedSpotIndicator:
                        (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          FlLine(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                          ),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 6,
                              color: Theme.of(context).colorScheme.primary,
                              strokeWidth: 2,
                              strokeColor:
                                  isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          return LineTooltipItem(
                            NumberFormat("0.00", "tr_TR").format(touchedSpot.y),
                            TextStyle(
                              color: isDarkMode ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              languageProvider.translate('last_10_days_changes'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (last10DaysChanges != null)
              Expanded(
                child: ListView.builder(
                  itemCount: last10DaysChanges!.length,
                  itemBuilder: (context, index) {
                    final change = last10DaysChanges![index];
                    final date = change['date'] as DateTime;
                    final changePercent = change['change'] as double;
                    final isPositive = changePercent > 0;

                    return ListTile(
                      leading: Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        DateFormat('dd.MM.yyyy').format(date),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: Text(
                        '${changePercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
