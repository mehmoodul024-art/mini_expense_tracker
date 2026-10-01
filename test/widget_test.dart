import 'package:flutter_test/flutter_test.dart';
import 'package:mini_expense_tracker/main.dart';

void main() {
  testWidgets('expense tracker loads', (tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    expect(find.text('Total spent'), findsOneWidget);

    expect(find.text('Add Expense'), findsOneWidget);
  });
}
