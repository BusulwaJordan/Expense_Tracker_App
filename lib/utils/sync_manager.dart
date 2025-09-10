import '../services/database_helper.dart';
import '../services/supabase_service.dart';

class SyncManager {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final SupabaseService _supabaseService = SupabaseService();

  Future<void> syncData() async {
    try {
      // Push local unsynced changes to cloud
      final unsyncedExpenses =
          _dbHelper.getUnsyncedExpenses(); // Hive is synchronous
      for (final expense in unsyncedExpenses) {
        await _supabaseService.syncExpense(expense);
        await _dbHelper.markAsSynced(expense.id!);
      }

      // Pull cloud changes to local
      final cloudExpenses = await _supabaseService.getExpenses();
      for (final expense in cloudExpenses) {
        // Check if expense already exists locally
        final existingExpenses = _dbHelper.getExpenses();
        final exists = existingExpenses.any((e) => e.id == expense.id);

        if (!exists) {
          await _dbHelper.insertExpense(expense);
        }
      }
    } catch (e) {
      throw Exception('Sync failed: $e');
    }
  }

  Future<bool> trySync() async {
    try {
      final isConnected = await _supabaseService.isConnected();
      if (isConnected) {
        await syncData();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
