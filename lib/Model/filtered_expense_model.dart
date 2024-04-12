import 'expense_model.dart';

class FilteredExpenseModel {
  String name;
  num totalAmt;
  List<ExpenseModel> arrExpenses;

  FilteredExpenseModel(
      {required this.name,
        required this.totalAmt,
        required this.arrExpenses,
      });
}
