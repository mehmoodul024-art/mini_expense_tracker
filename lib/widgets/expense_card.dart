import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_theme.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final bool showDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
    this.onEdit,
    this.showDelete = true,
  });

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

  Color _colorForCategory(String category) {
    switch (category) {
      case 'Food':
        return const Color(0xFFFF8A65);

      case 'Transport':
        return const Color(0xFF7EA7FF);

      case 'Shopping':
        return const Color(0xFFC19BFF);

      case 'Bills':
        return const Color(0xFFFFC857);

      case 'Education':
        return const Color(0xFF69E6C0);

      case 'Entertainment':
        return const Color(0xFFFF78B5);

      default:
        return AppTheme.primaryLight;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _colorForCategory(expense.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: AppTheme.surface,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withValues(alpha: 0.045)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.13),

                borderRadius: BorderRadius.circular(17),
              ),

              child: Icon(
                _iconForCategory(expense.category),

                color: categoryColor,

                size: 24,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    expense.title,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: AppTheme.textPrimary,

                      fontSize: 16,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${expense.category}  •  ${_formatDate(expense.date)}',

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: AppTheme.textSecondary,

                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text(
                  'Rs. ${expense.amount.toStringAsFixed(0)}',

                  style: const TextStyle(
                    color: AppTheme.textPrimary,

                    fontSize: 15,

                    fontWeight: FontWeight.w800,
                  ),
                ),

                if (onEdit != null)
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: 'Edit',
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),

                if (showDelete)
                  SizedBox(
                    width: 34,
                    height: 34,

                    child: IconButton(
                      padding: EdgeInsets.zero,

                      tooltip: 'Delete',

                      onPressed: onDelete,

                      icon: const Icon(
                        Icons.delete_outline_rounded,

                        size: 19,

                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
