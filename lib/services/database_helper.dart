import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const String _expenseBoxName = 'expenses';
  late Box<Map<dynamic, dynamic>> _expenseBox; // Changed to dynamic keys
  bool _isInitialized = false;

  // Initialize Hive and open the box
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
    _expenseBox = await Hive.openBox<Map<dynamic, dynamic>>(_expenseBoxName);
    _isInitialized = true;
  }

  // Convert Expense to Map
  Map<String, dynamic> _expenseToMap(Expense expense) {
    return {
      'id': expense.id,
      'amount': expense.amount,
      'category': expense.category,
      'date': expense.date.toIso8601String(),
      'notes': expense.notes,
      'synced': expense.synced,
      'created_at': expense.createdAt?.toIso8601String(),
      'updated_at': expense.updatedAt?.toIso8601String(),
    };
  }

  // Convert Map to Expense with proper type handling
  Expense _mapToExpense(Map<dynamic, dynamic> map) {
    // Convert dynamic map to String-keyed map
    final stringMap = Map<String, dynamic>.from(map);

    return Expense(
      id: stringMap['id'],
      amount: (stringMap['amount'] as num).toDouble(),
      category: stringMap['category'],
      date: DateTime.parse(stringMap['date']),
      notes: stringMap['notes'],
      synced: stringMap['synced'] ?? false,
      createdAt: stringMap['created_at'] != null
          ? DateTime.parse(stringMap['created_at'])
          : null,
      updatedAt: stringMap['updated_at'] != null
          ? DateTime.parse(stringMap['updated_at'])
          : null,
    );
  }

  // Get all expenses sorted by date (newest first)
  List<Expense> getExpenses() {
    final expenses = _expenseBox.values.map(_mapToExpense).toList();
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  // Get expenses by date range
  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenseBox.values
        .map(_mapToExpense)
        .where((expense) =>
            expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
            expense.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Add a new expense
  Future<void> insertExpense(Expense expense) async {
    await _expenseBox.add(_expenseToMap(expense));
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    final key = _getKeyForExpense(expense);
    if (key != null) {
      final updatedExpense = expense.copyWith(updatedAt: DateTime.now());
      await _expenseBox.put(key, _expenseToMap(updatedExpense));
    }
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    final key = _getKeyForExpenseById(id);
    if (key != null) {
      await _expenseBox.delete(key);
    }
  }

  // Get unsynced expenses
  List<Expense> getUnsyncedExpenses() {
    return _expenseBox.values
        .map(_mapToExpense)
        .where((expense) => !expense.synced)
        .toList();
  }

  // Mark an expense as synced
  Future<void> markAsSynced(String id) async {
    final key = _getKeyForExpenseById(id);
    if (key != null) {
      final expenseMap = _expenseBox.get(key);
      if (expenseMap != null) {
        // Convert to String-keyed map, update, then put back
        final updatedMap = Map<String, dynamic>.from(expenseMap);
        updatedMap['synced'] = true;
        updatedMap['updated_at'] = DateTime.now().toIso8601String();
        await _expenseBox.put(key, updatedMap);
      }
    }
  }

  // Helper method to get the Hive key for an expense
  int? _getKeyForExpense(Expense expense) {
    try {
      final entry = _expenseBox
          .toMap()
          .entries
          .firstWhere((entry) => entry.value['id'] == expense.id);
      return entry.key;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get the Hive key for an expense by ID
  int? _getKeyForExpenseById(String id) {
    try {
      final entry = _expenseBox
          .toMap()
          .entries
          .firstWhere((entry) => entry.value['id'] == id);
      return entry.key;
    } catch (e) {
      return null;
    }
  }

  // Close the database
  Future<void> close() async {
    if (_isInitialized) {
      await _expenseBox.close();
      _isInitialized = false;
    }
  }

  // Clear all data (for testing/debugging)
  Future<void> clearAll() async {
    await _expenseBox.clear();
  }

  // Get expense count
  int get expenseCount => _expenseBox.length;

  // Get total amount of all expenses
  double getTotalAmount() {
    return _expenseBox.values
        .map(_mapToExpense)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get category totals
  Map<String, double> getCategoryTotals() {
    final Map<String, double> totals = {};
    for (final expense in _expenseBox.values.map(_mapToExpense)) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }
}
