import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/expense.dart';
import 'screens/add_expense_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/expense_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  final List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final savedExpenses = prefs.getStringList('expenses');

    if (savedExpenses == null) {
      return;
    }

    try {
      final loadedExpenses = savedExpenses.map((expenseString) {
        final expenseMap = jsonDecode(expenseString) as Map<String, dynamic>;
        return Expense.fromMap(expenseMap);
      }).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _expenses
          ..clear()
          ..addAll(loadedExpenses);
      });
    } catch (_) {
      // Ignore invalid old saved data and keep the app usable.
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();

    final expensesToSave = _expenses
        .map((expense) => jsonEncode(expense.toMap()))
        .toList();

    await prefs.setStringList('expenses', expensesToSave);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });

    _saveExpenses();
  }

  void _editExpense(Expense updatedExpense) {
    setState(() {
      final index = _expenses.indexWhere(
        (expense) => expense.id == updatedExpense.id,
      );

      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
    });

    _saveExpenses();
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });

    _saveExpenses();
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case '/add-expense':
        page = AddExpenseScreen(onAddExpense: _addExpense);
        break;

      case '/expenses':
        page = ExpenseListScreen(
          expenses: _expenses,
          onDeleteExpense: _deleteExpense,
          onEditExpense: _editExpense,
        );
        break;

      default:
        return null;
    }

    return PageRouteBuilder(
      settings: settings,

      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },

      transitionDuration: const Duration(milliseconds: 450),

      reverseTransitionDuration: const Duration(milliseconds: 350),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,

          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(curved),

            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Spendly',

      theme: AppTheme.dark(),

      home: DashboardScreen(expenses: _expenses),

      onGenerateRoute: _onGenerateRoute,
    );
  }
}
