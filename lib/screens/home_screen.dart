import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/expense_provider.dart';
import '../widgets/expense_tile.dart';
import '../widgets/custom_card.dart';
import '../widgets/loading_shimmer.dart';
import 'add_edit_expense_screen.dart';
import 'charts_screen.dart';
import 'package:expense_tracker_1/models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    ChartsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().loadExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => context.read<ExpenseProvider>().manualSync(),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddExpense(context),
        child: const Icon(Icons.add, size: 30),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(duration: 300.ms),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.bar_chart, 'Charts'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return IconButton(
      icon: Icon(icon,
          color: _selectedIndex == index
              ? Theme.of(context).colorScheme.primary
              : Colors.grey),
      onPressed: () => setState(() => _selectedIndex = index),
    );
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditExpenseScreen(),
      ),
    ).then((_) => context.read<ExpenseProvider>().loadExpenses());
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Column(
      children: [
        // Summary Cards
        _buildSummarySection(context, provider),

        // Expenses List
        Expanded(
          child: provider.isLoading
              ? const LoadingShimmer()
              : _buildExpensesList(context, provider),
        ),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context, ExpenseProvider provider) {
    final total = provider.getTotalExpenses();
    final categoryTotals = provider.getCategoryTotals();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          CustomCard(
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Total Expenses',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text('\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary)),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: ListTile(
                    leading: Icon(Icons.wifi,
                        color: provider.isOnline ? Colors.green : Colors.grey),
                    title: Text(provider.isOnline ? 'Online' : 'Offline',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomCard(
                  child: ListTile(
                    leading: Icon(Icons.list,
                        color: Theme.of(context).colorScheme.secondary),
                    title: Text('${provider.expenses.length} expenses',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context, ExpenseProvider provider) {
    if (provider.expenses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No expenses yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text('Tap + to add your first expense',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: provider.expenses.length,
      itemBuilder: (context, index) {
        final expense = provider.expenses[index];
        return ExpenseTile(
          expense: expense,
          onTap: () => _navigateToEditExpense(context, expense),
          onDelete: () => _deleteExpense(context, expense),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(
              begin: 0.5,
              curve: Curves.easeOut,
            );
      },
    );
  }

  void _navigateToEditExpense(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpenseScreen(expense: expense),
      ),
    ).then((_) => context.read<ExpenseProvider>().loadExpenses());
  }

  void _deleteExpense(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ExpenseProvider>().deleteExpense(expense.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
