import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_card.dart';

class DashboardScreen extends StatefulWidget {
  final List<Expense> expenses;

  const DashboardScreen({super.key, required this.expenses});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;

  late final Animation<Offset> _slideAnimation;

  double get _totalExpense {
    return widget.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  int get _categoryCount {
    return widget.expenses.map((expense) => expense.category).toSet().length;
  }

  List<Expense> get _recentExpenses {
    final sorted = List<Expense>.from(widget.expenses)
      ..sort((a, b) => b.date.compareTo(a.date));

    return sorted.take(3).toList();
  }

  String get _greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    }

    if (hour < 18) {
      return 'Good afternoon';
    }

    return 'Good evening';
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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

  Future<void> _openExpenses() async {
    await Navigator.pushNamed(context, '/expenses');

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(height: 26),

                  _buildHeroCard(),

                  const SizedBox(height: 18),

                  _buildStats(),

                  const SizedBox(height: 28),

                  _buildQuickActions(),

                  const SizedBox(height: 28),

                  _buildRecentHeader(),

                  const SizedBox(height: 13),

                  _buildRecentExpenses(),

                  const SizedBox(height: 14),

                  _buildViewAllButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFFB6A5),
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: const Text(
            'SK',
            style: TextStyle(
              color: Color(0xFF7E2410),
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Here is your money at a glance',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        _CircleIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are all caught up.')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 21, 22, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total spent',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _totalExpense),
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Text(
                'Rs. ${value.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _HeroPill(
                icon: Icons.receipt_long_rounded,
                text: '${widget.expenses.length} expenses',
              ),
              const SizedBox(width: 8),
              const _HeroPill(
                icon: Icons.auto_awesome_rounded,
                text: 'Live total',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.receipt_long_rounded,
            value: '${widget.expenses.length}',
            label: 'Expenses',
            iconColor: AppTheme.lavender,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.category_rounded,
            value: '$_categoryCount',
            label: 'Categories',
            iconColor: AppTheme.mint,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.add_rounded,
            label: 'Add Expense',
            color: AppTheme.primary,
            onTap: _openAddExpense,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.swap_horiz_rounded,
            label: 'View All',
            color: AppTheme.lavender,
            onTap: _openExpenses,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Recent activity',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(onPressed: _openExpenses, child: const Text('See all')),
      ],
    );
  }

  Widget _buildRecentExpenses() {
    if (_recentExpenses.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.045)),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.visibility_outlined,
                color: AppTheme.primaryLight,
                size: 28,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Show me the money 👀',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your first expense will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _recentExpenses
          .map(
            (expense) => ExpenseCard(
              expense: expense,
              onDelete: () {},
              showDelete: false,
            ),
          )
          .toList(),
    );
  }

  Widget _buildViewAllButton() {
    return OutlinedButton.icon(
      onPressed: _openExpenses,
      icon: const Icon(Icons.arrow_forward_rounded),
      label: const Text('Open expense list'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: AppTheme.textPrimary,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.09)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceSoft,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: AppTheme.textPrimary),
        ),
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.045)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });

        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
          decoration: BoxDecoration(
            color: AppTheme.surfaceSoft,
            borderRadius: BorderRadius.circular(21),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 21),
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
