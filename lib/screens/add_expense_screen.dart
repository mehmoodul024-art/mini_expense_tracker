import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_theme.dart';

class AddExpenseScreen extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;
  final Expense? expense;

  const AddExpenseScreen({super.key, required this.onAddExpense, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  final List<String> _categories = const [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Education',
    'Entertainment',
    'Other',
  ];

  String _selectedCategory = 'Food';

  DateTime _selectedDate = DateTime.now();

  bool _saving = false;

  bool get _isEditing => widget.expense != null;

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;

      case 'Transport':
        return Icons.directions_car_rounded;

      case 'Shopping':
        return Icons.shopping_bag_rounded;

      case 'Bills':
        return Icons.receipt_long_rounded;

      case 'Education':
        return Icons.school_rounded;

      case 'Entertainment':
        return Icons.movie_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  @override
  void initState() {
    super.initState();

    final expense = widget.expense;

    if (expense != null) {
      _titleController.text = expense.title;
      _amountController.text = expense.amount.toString();
      _selectedCategory = expense.category;
      _selectedDate = expense.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final baseTheme = Theme.of(context);

        return Theme(
          data: baseTheme.copyWith(
            colorScheme: baseTheme.colorScheme.copyWith(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: AppTheme.surface,
              onSurface: AppTheme.textPrimary,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.surface,
              surfaceTintColor: Colors.transparent,
              headerBackgroundColor: AppTheme.primary,
              headerForegroundColor: Colors.white,
              weekdayStyle: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w700,
              ),
              dayStyle: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              todayForegroundColor: WidgetStatePropertyAll(AppTheme.primary),
              todayBorder: const BorderSide(color: AppTheme.primary),
              yearStyle: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    FocusScope.of(context).unfocus();

    final expense = Expense(
      id:
          widget.expense?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _selectedCategory,
      date: _selectedDate,
    );

    widget.onAddExpense(expense);

    await Future<void>.delayed(const Duration(milliseconds: 180));

    if (!mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          _isEditing ? 'Edit expense' : 'Add expense',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Update the expense.' : 'Make a note of it.',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  _isEditing
                      ? 'Update the details and keep your spending accurate.'
                      : 'A tiny habit that keeps your spending visible.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Amount',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    prefixText: 'Rs. ',
                    prefixStyle: TextStyle(
                      color: AppTheme.primaryLight,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter an amount';
                    }

                    final amount = double.tryParse(value.trim());

                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount greater than 0';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'What was it for?',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Dinner with friends',
                    prefixIcon: Icon(Icons.edit_note_rounded),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';

                    if (text.isEmpty) {
                      return 'Enter an expense title';
                    }

                    if (text.length < 2) {
                      return 'Title is too short';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                const Text(
                  'Category',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 9,
                  children: _categories.map((category) {
                    final selected = category == _selectedCategory;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      child: ChoiceChip(
                        selected: selected,
                        avatar: Icon(
                          _iconForCategory(category),
                          size: 16,
                          color: selected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                        label: Text(category),
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppTheme.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.surfaceSoft,
                        side: BorderSide(
                          color: selected
                              ? Colors.transparent
                              : Colors.white.withValues(alpha: 0.05),
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Date',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 9),

                Material(
                  color: AppTheme.surfaceSoft,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: _selectDate,
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Row(
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: AppTheme.lavender.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: AppTheme.lavender,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              _formatDate(_selectedDate),
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppTheme.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                FilledButton.icon(
                  onPressed: _saving ? null : _saveExpense,
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(
                    _saving
                        ? (_isEditing ? 'Updating...' : 'Saving...')
                        : (_isEditing ? 'Update expense' : 'Save expense'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
