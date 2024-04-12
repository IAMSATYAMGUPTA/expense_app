import 'dart:async';

import 'package:expense_app/Model/expense_model.dart';
import 'package:expense_app/Screens/Home_Screen/Add%20Transection/bloc/expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Constant/app_constant.dart';
import '../../../Custom_Widget/app_custom_widget.dart';
import '../../../Model/expense_entries_model.dart';
import '../../../Model/filtered_expense_model.dart';
import '../../../Services/graph_provider.dart';

class WeekExpensesPage extends StatefulWidget {
  const WeekExpensesPage({Key? key}) : super(key: key);

  @override
  State<WeekExpensesPage> createState() => _WeekExpensesPageState();
}

class _WeekExpensesPageState extends State<WeekExpensesPage> {

  List<FilteredExpenseModel> arrWeekWiseExpenses = [];
  List<ExpenseUniqueEntries> arrItemEntries = [];
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
          filterExpensesByWeek(state.listExpenses);
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
      },)
    );
  }

  void filterExpensesByWeek(List<ExpenseModel> listExpenses){
    arrWeekWiseExpenses.clear();
    List<String> currentWeek=[];
    List<int> expID = [];

    List<String> arrLastSevenDays=[];
    var date = DateTime.now();
    var todayDate = DateFormat('d').format(DateTime.parse(date.toString())).toString();

    for(int i=0;i<7;i++){
      var currDate = todayDate;
      if(todayDate.toString().length==2){
        arrLastSevenDays.add(currDate);
      }else{
        currDate = "0${currDate}";
        arrLastSevenDays.add(currDate);
      }
      todayDate = (int.parse(todayDate.toString())-1).toString();
    }

    for(String currDate in arrLastSevenDays){
      for(ExpenseModel eachExp in listExpenses){
        var eachDate = DateTime.parse(eachExp.exp_time);
        var mDate = eachDate.toString().substring(0,11);
        var allDates = eachDate.toString().substring(8,10);
        if(!currentWeek.contains(mDate)){
          if(currDate==allDates){
            currentWeek.add(mDate);
          }
        }
      }
    }

    /// step 2 (unique dates expenses)
    for (String eachUniqueWeekDate in currentWeek) {
      var currenDay;

      List<ExpenseModel> eachWeekDateExpenses = [];
      num eachDateAmt = 0;

      for (ExpenseModel eachExp in listExpenses) {
        if(eachExp.exp_time.contains(eachUniqueWeekDate)){
          eachWeekDateExpenses.add(eachExp);
          expID.add(eachExp.expe_cat_id);
          currenDay = DateFormat('E').format(DateTime.parse(eachExp.exp_time));

          if (eachExp.exp_type == 0) {
            //debit
            eachDateAmt -= eachExp.exp_amt;
          } else {
            //credit
            eachDateAmt += eachExp.exp_amt;
          }

        }

      }

      num amt = eachDateAmt;

      if(amt<0){
        amt = num.parse(amt.toString().substring(1,(amt.toString().length)));
      }

      if(amt>maxAmt){
        maxAmt = amt;
      }

      arrWeekWiseExpenses.add(FilteredExpenseModel(
          name: currenDay,
          totalAmt: eachDateAmt,
          arrExpenses: eachWeekDateExpenses
      ));

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
      Provider.of<GraphProvider>(context,listen: false).setGraphData(arrWeekWiseExpenses);
      Provider.of<GraphProvider>(context,listen: false).setMaxAmount(maxAmt);
    });


  }

}
