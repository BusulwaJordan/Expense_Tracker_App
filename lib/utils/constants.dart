import 'package:flutter/material.dart';

const String supabaseUrl = 'https://opqgsbrqnnmkobxjarqk.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wcWdzYnJxbm5ta29ieGphcnFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0OTYyNzAsImV4cCI6MjA3MzA3MjI3MH0.cPN0iz9gpWBgRJmARGiIAx3BqWTPXOH7Q7pq1c2haeo';

const List<String> categories = [
  'Food',
  'Transport',
  'Entertainment',
  'Groceries',
  'Utilities',
  'Others'
];

const Map<String, Color> categoryColors = {
  'Food': Color(0xFFFF6B6B),
  'Transport': Color(0xFF4ECDC4),
  'Entertainment': Color(0xFFFFD166),
  'Groceries': Color(0xFF06D6A0),
  'Utilities': Color(0xFF118AB2),
  'Others': Color(0xFF073B4C),
};

const Map<String, IconData> categoryIcons = {
  'Food': Icons.restaurant,
  'Transport': Icons.directions_car,
  'Entertainment': Icons.movie,
  'Groceries': Icons.shopping_cart,
  'Utilities': Icons.bolt,
  'Others': Icons.category,
};
