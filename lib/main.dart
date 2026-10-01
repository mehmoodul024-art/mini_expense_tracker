import 'package:flutter/material.dart';

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

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
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
