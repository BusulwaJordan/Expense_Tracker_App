import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_1/models/expense.dart';

void main() {
  group('Expense Model Tests', () {
    test('Expense should convert to and from map correctly', () {
      final expense = Expense(
        id: '1',
        amount: 100.0,
        category: 'Food',
        date: DateTime(2023, 1, 1),
        notes: 'Test expense',
      );

      final map = expense.toMap();
      final fromMap = Expense.fromMap(map);

      expect(fromMap.id, expense.id);
      expect(fromMap.amount, expense.amount);
      expect(fromMap.category, expense.category);
      expect(fromMap.date, expense.date);
      expect(fromMap.notes, expense.notes);
    });

    test('Expense copyWith should work correctly', () {
      final original = Expense(
        amount: 100.0,
        category: 'Food',
        date: DateTime(2023, 1, 1),
      );

      final copied = original.copyWith(
        amount: 200.0,
        category: 'Transport',
      );

      expect(copied.amount, 200.0);
      expect(copied.category, 'Transport');
      expect(copied.date, original.date);
    });
  });
}
