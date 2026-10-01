import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_card.dart';

class ExpenseListScreen extends StatefulWidget {
  final List<Expense> expenses;

  final void Function(String id) onDeleteExpense;

  const ExpenseListScreen({
    super.key,
    required this.expenses,
    required this.onDeleteExpense,
  });

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  String _selectedCategory = 'All';

  List<String> get _categories {
    final categories =
        widget.expenses.map((expense) => expense.category).toSet().toList()
          ..sort();

    return ['All', ...categories];
  }

  List<Expense> get _filteredExpenses {
    final result = widget.expenses.where((expense) {
      final search = _searchQuery.toLowerCase();

      final matchesSearch =
          expense.title.toLowerCase().contains(search) ||
          expense.category.toLowerCase().contains(search);

      final matchesCategory =
          _selectedCategory == 'All' || expense.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    result.sort((a, b) => b.date.compareTo(a.date));

    return result;
  }

  double get _totalExpense {
    return widget.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _openAddExpense() async {
    final result = await Navigator.pushNamed(context, '/add-expense');

    if (!mounted) return;

    setState(() {});

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully.')),
      );
    }
  }

  Future<void> _confirmDelete(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,

          title: const Text(
            'Delete expense?',

            style: TextStyle(fontWeight: FontWeight.w800),
          ),

          content: Text('Remove "${expense.title}" from your list?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },

              child: const Text('Cancel'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),

              onPressed: () {
                Navigator.pop(dialogContext, true);
              },

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    widget.onDeleteExpense(expense.id);

    if (_selectedCategory != 'All' &&
        !widget.expenses.any((item) => item.category == _selectedCategory)) {
      _selectedCategory = 'All';
    }

    setState(() {});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Expense deleted.')));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredExpenses;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 74,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Your expenses',

              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),

            Text(
              '${widget.expenses.length} records  •  Rs. ${_totalExpense.toStringAsFixed(0)} total',

              style: const TextStyle(
                color: AppTheme.textSecondary,

                fontSize: 11,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),

            child: IconButton.filledTonal(
              onPressed: _openAddExpense,

              icon: const Icon(Icons.add_rounded),

              tooltip: 'Add expense',
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),

            child: TextField(
              controller: _searchController,

              decoration: InputDecoration(
                hintText: 'Search expenses or categories',

                prefixIcon: const Icon(Icons.search_rounded),

                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _searchController.clear,

                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ),

          SizedBox(
            height: 46,

            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              scrollDirection: Axis.horizontal,

              itemCount: _categories.length,

              separatorBuilder: (_, __) => const SizedBox(width: 8),

              itemBuilder: (context, index) {
                final category = _categories[index];

                final selected = category == _selectedCategory;

                return ChoiceChip(
                  selected: selected,

                  label: Text(category),

                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppTheme.textSecondary,

                    fontWeight: FontWeight.w700,
                  ),

                  selectedColor: AppTheme.primary,

                  backgroundColor: AppTheme.surfaceSoft,

                  side: BorderSide(
                    color: selected
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.04),
                  ),

                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),

              child: filtered.isEmpty
                  ? _EmptyListState(
                      key: ValueKey(
                        '${widget.expenses.length}-$_searchQuery-$_selectedCategory',
                      ),

                      hasExpenses: widget.expenses.isNotEmpty,

                      onAdd: _openAddExpense,
                    )
                  : ListView.builder(
                      key: const ValueKey('expense-list'),

                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),

                      physics: const BouncingScrollPhysics(),

                      itemCount: filtered.length,

                      itemBuilder: (context, index) {
                        final expense = filtered[index];

                        return ExpenseCard(
                          expense: expense,

                          onDelete: () => _confirmDelete(expense),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpense,

        backgroundColor: AppTheme.primary,

        foregroundColor: Colors.white,

        icon: const Icon(Icons.add_rounded),

        label: const Text(
          'Add expense',

          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _EmptyListState extends StatelessWidget {
  final bool hasExpenses;
  final VoidCallback onAdd;

  const _EmptyListState({
    super.key,
    required this.hasExpenses,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 76,
              height: 76,

              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.search_off_rounded,

                color: AppTheme.primaryLight,

                size: 32,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              hasExpenses ? 'Nothing matches that search' : 'No expenses yet',

              textAlign: TextAlign.center,

              style: const TextStyle(
                color: AppTheme.textPrimary,

                fontSize: 19,

                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              hasExpenses
                  ? 'Try another word or category.'
                  : 'Add your first expense and start tracking.',

              textAlign: TextAlign.center,

              style: const TextStyle(color: AppTheme.textSecondary),
            ),

            if (!hasExpenses) ...[
              const SizedBox(height: 18),

              FilledButton.icon(
                onPressed: onAdd,

                icon: const Icon(Icons.add_rounded),

                label: const Text('Add first expense'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
