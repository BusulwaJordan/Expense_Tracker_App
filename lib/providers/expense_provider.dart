import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/database_helper.dart';
import '../services/supabase_service.dart';
import '../utils/sync_manager.dart';

class ExpenseProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final SupabaseService _supabaseService = SupabaseService();
  final SyncManager _syncManager = SyncManager();

  List<Expense> _expenses = [];
  bool _isLoading = false;
  bool _isOnline = false;
  bool _isInitialized = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;

  // Initialize the database
  Future<void> _initialize() async {
    if (!_isInitialized) {
      await _dbHelper.init();
      _isInitialized = true;
    }
  }

  Future<void> loadExpenses() async {
    await _initialize(); // Ensure database is initialized

    _isLoading = true;
    notifyListeners();

    try {
      _expenses = _dbHelper.getExpenses(); // Hive is synchronous

      // Try to sync in background
      _isOnline = await _supabaseService.isConnected();
      if (_isOnline) {
        await _syncManager.trySync();
        _expenses = _dbHelper.getExpenses(); // Reload after sync
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading expenses: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    await _initialize(); // Ensure database is initialized

    try {
      final newExpense = expense.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );

      await _dbHelper.insertExpense(newExpense);
      _expenses.insert(0, newExpense);

      if (_isOnline) {
        await _syncManager.trySync();
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    await _initialize(); // Ensure database is initialized

    try {
      await _dbHelper.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
      }

      if (_isOnline) {
        await _syncManager.trySync();
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    await _initialize(); // Ensure database is initialized

    try {
      await _dbHelper.deleteExpense(id);
      _expenses.removeWhere((expense) => expense.id == id);

      if (_isOnline) {
        await _supabaseService.deleteExpense(id);
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  Future<List<Expense>> getExpensesByDateRange(
      DateTime start, DateTime end) async {
    await _initialize(); // Ensure database is initialized
    return _dbHelper.getExpensesByDateRange(start, end); // Hive is synchronous
  }

  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getCategoryTotals() {
    final Map<String, double> totals = {};
    for (final expense in _expenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  void setOnlineStatus(bool status) {
    _isOnline = status;
    notifyListeners();
  }

  Future<void> manualSync() async {
    await _initialize(); // Ensure database is initialized

    _isLoading = true;
    notifyListeners();

    try {
      await _syncManager.syncData();
      await loadExpenses();
    } catch (e) {
      throw Exception('Manual sync failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Additional helper methods that might be useful
  int get expenseCount => _expenses.length;

  // Clear all expenses (for debugging/testing)
  Future<void> clearAllExpenses() async {
    await _initialize();
    // You might want to add a clearAll method to DatabaseHelper
    // await _dbHelper.clearAll();
    _expenses.clear();
    notifyListeners();
  }

  // Dispose method to clean up resources
  @override
  void dispose() {
    _dbHelper.close();
    super.dispose();
  }
}
