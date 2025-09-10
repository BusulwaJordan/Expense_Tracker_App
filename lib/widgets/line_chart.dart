import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<dynamic> expenses;

  const LineChartWidget({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Group expenses by month
    final monthlyData = _groupByMonth(expenses);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: monthlyData.entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                entry.value,
              );
            }).toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            belowBarData: BarAreaData(show: true),
          ),
        ],
      ),
    );
  }

  Map<int, double> _groupByMonth(List<dynamic> expenses) {
    final Map<int, double> monthlyTotals = {};

    for (final expense in expenses) {
      final month = expense.date.month;
      monthlyTotals.update(
        month,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return monthlyTotals;
  }
}
