import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> syncExpense(Expense expense) async {
    try {
      await _client.from('expenses').upsert({
        'id': expense.id,
        'amount': expense.amount,
        'category': expense.category,
        'date': expense.date.toIso8601String(),
        'notes': expense.notes,
        'created_at': expense.createdAt?.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to sync expense: $e');
    }
  }

  Future<List<Expense>> getExpenses() async {
    try {
      final response = await _client
          .from('expenses')
          .select()
          .order('date', ascending: false);

      return (response as List<dynamic>)
          .map((e) => Expense(
                id: e['id'],
                amount: e['amount'],
                category: e['category'],
                date: DateTime.parse(e['date']),
                notes: e['notes'],
                synced: true,
                createdAt: e['created_at'] != null
                    ? DateTime.parse(e['created_at'])
                    : null,
                updatedAt: e['updated_at'] != null
                    ? DateTime.parse(e['updated_at'])
                    : null,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _client.from('expenses').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  Future<bool> isConnected() async {
    try {
      await _client.from('expenses').select('count').limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }
}
