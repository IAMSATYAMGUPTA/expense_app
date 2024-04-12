import 'dart:async';

import 'package:expense_app/Model/expense_model.dart';
import 'package:expense_app/Model/filtered_expense_model.dart';
import 'package:expense_app/Screens/Home_Screen/Add%20Transection/bloc/expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Constant/app_constant.dart';
import '../../../Custom_Widget/app_custom_widget.dart';
import '../../../Model/expense_entries_model.dart';
import '../../../Services/graph_provider.dart';

class MonthExpensesPage extends StatefulWidget {
  const MonthExpensesPage({Key? key}) : super(key: key);

  @override
  State<MonthExpensesPage> createState() => _MonthExpensesPageState();
}

class _MonthExpensesPageState extends State<MonthExpensesPage> {

  List<FilteredExpenseModel> arrMonthWiseExpenses = [];
  List<ExpenseUniqueEntries> arrItemEntries = [];
  var currentMonth;
  num maxAmt = 0;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchAllExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExpenseBloc,ExpenseState>(
          builder: (context, state) {
            if(state is ExpenseLoadedState){
              filterExpensesByMonth(state.listExpenses);
              return ListView.builder(
                itemCount: arrItemEntries.length,
                itemBuilder: (context, index) {
                  var imgPath="";
                  var entryName;
                  for(Map<String,dynamic> cat in AppConstants.categories){
                    if(cat['id']==arrItemEntries[index].id){
                      imgPath = cat['img'];
                      entryName = cat['name'];
                      break;
                    }
                  }
                  return ListTile(
                    leading: Image.asset(imgPath,width: 40,height: 40,),
                    title: Text(entryName,style: TextStyle(fontWeight: FontWeight.w600),),
                    subtitle: Text(arrItemEntries[index].totalEntry.toString()+" entries",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  );
                },
              );
            }
            else if(state is ExpenseLoadingState){
              return Center(child: CircularProgressIndicator(),);
            }
            return Container();
          },
      ),
    );
  }

  void filterExpensesByMonth(List<ExpenseModel> listExpenses) {
    arrMonthWiseExpenses.clear();
    List<String> arrUniqueMonth = [];
    List<int> expID = [];
    int mCount=0;

    /// step 1 (for unique month)
    for(ExpenseModel eachExp in listExpenses){

      var eachDate = DateTime.parse(eachExp.exp_time);

      var mMonth = "${eachDate.year}"
          "-${eachDate.month.toString().length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}";

      if (!arrUniqueMonth.contains(mMonth)) {
        arrUniqueMonth.add(mMonth);
      }

    }

    /// step 2 (unique month expenses)
    for (String eachUniqueMonth in arrUniqueMonth) {
      mCount++;
      List<ExpenseModel> eachMonthExpenses = [];
      num eachMonthAmt = 0;

      for(ExpenseModel eachExp in listExpenses){
        currentMonth = DateFormat('MMMM').format(DateTime.parse(eachExp.exp_time)).toString();
        if(eachExp.exp_time.contains(eachUniqueMonth)){
          eachMonthExpenses.add(eachExp);
          expID.add(eachExp.expe_cat_id);

          if (eachExp.exp_type == 0) {
            //debit
            eachMonthAmt -= eachExp.exp_amt;
          } else {
            //credit
            eachMonthAmt += eachExp.exp_amt;
          }

        }
      }

      num amt = eachMonthAmt;

      if(amt<0){
        amt = num.parse(amt.toString().substring(1,(amt.toString().length)));
      }

      if(amt>maxAmt){
        maxAmt = amt;
      }

      arrMonthWiseExpenses.add(FilteredExpenseModel(
          name: currentMonth,
          totalAmt: eachMonthAmt,
          arrExpenses: eachMonthExpenses));

      if(mCount==12){
        break;
      }

    }

    uniqueExpEntries(expID);

  }

  void uniqueExpEntries(List<int> allID) {
    arrItemEntries.clear();

    List<int> expuniqueID = [];

    for(int id in allID){
      if(!expuniqueID.contains(id)){
        expuniqueID.add(id);
      }
    }

    for(int uniqueID in expuniqueID){
      int count = 0;
      for(int id in allID){
        if(id==uniqueID){
          count++;
        }
      }
      arrItemEntries.add(ExpenseUniqueEntries(
          id: uniqueID,
          totalEntry: count));
    }

    Timer(Duration(milliseconds: 400), () {
      Provider.of<GraphProvider>(context,listen: false).setGraphData(arrMonthWiseExpenses);
      Provider.of<GraphProvider>(context,listen: false).setMaxAmount(maxAmt);
    });

  }

}
