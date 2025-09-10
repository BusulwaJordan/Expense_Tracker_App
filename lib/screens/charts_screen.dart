import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_1/providers/expense_provider.dart';
import 'package:expense_tracker_1/widgets/pie_chart.dart';
import 'package:expense_tracker_1/widgets/line_chart.dart';
import 'package:expense_tracker_1/widgets/custom_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final categoryTotals = provider.getCategoryTotals();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Pie Chart
          CustomCard(
            child: Column(
              children: [
                Text('Spending by Category',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  child: PieChartWidget(data: categoryTotals),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.5),

          const SizedBox(height: 20),

          // Line Chart
          CustomCard(
            child: Column(
              children: [
                Text('Monthly Spending Trend',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  child: LineChartWidget(expenses: provider.expenses),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.5),

          const SizedBox(height: 20),

          // Category Breakdown
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category Breakdown',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                ...categoryTotals.entries.map((entry) => ListTile(
                      leading: Icon(Icons.circle,
                          color: _getCategoryColor(entry.key)),
                      title: Text(entry.key),
                      trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
                    )),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.5),
        ],
      ),
    );
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
