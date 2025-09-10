import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return PieChart(
      PieChartData(
        sections: _createSections(),
        centerSpaceRadius: 40,
        sectionsSpace: 4,
      ),
    );
  }

  List<PieChartSectionData> _createSections() {
    final total = data.values.fold(0.0, (sum, value) => sum + value);

    return data.entries.map((entry) {
      final percentage = (entry.value / total * 100).round();

      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: '$percentage%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Food': Colors.red,
      'Transport': Colors.blue,
      'Entertainment': Colors.orange,
      'Groceries': Colors.green,
      'Utilities': Colors.purple,
      'Others': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }
}
