import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../App Database/db_helper.dart';
import '../../../../Model/expense_model.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  DBHelper db;
  ExpenseBloc({required this.db}) : super(ExpenseInitialState()) {
    on<AddExpenseEvent>((event, emit) async{
      emit(ExpenseLoadingState());
      bool check = await db.addExpense(event.newExpense);
      if(check){
        var expenses = await db.getAllExpensesOfUser();
        emit(ExpenseLoadedState(listExpenses: expenses));
      } else {
        emit(ExpenseErrorState(errorMsg: "Expense not Added!!"));
      }
    });

    on<FetchAllExpenseEvent>((event, emit) async{
      emit(ExpenseLoadingState());
      var expenses = await db.getAllExpensesOfUser();
      emit(ExpenseLoadedState(listExpenses: expenses));
    });
  }
}
