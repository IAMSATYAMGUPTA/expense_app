import 'dart:async';

import 'package:expense_app/Model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../Constant/app_constant.dart';
import '../../../Custom_Widget/app_custom_widget.dart';
import '../../../Model/expense_entries_model.dart';
import '../../../Model/filtered_expense_model.dart';
import '../Add Transection/bloc/expense_bloc.dart';
import '../../../Services/graph_provider.dart';

class YearExpensesPage extends StatefulWidget {
  const YearExpensesPage({Key? key}) : super(key: key);

  @override
  State<YearExpensesPage> createState() => _YearExpensesPageState();
}

class _YearExpensesPageState extends State<YearExpensesPage> {

  List<FilteredExpenseModel> arrYearWiseExpenses = [];
  List<ExpenseUniqueEntries> arrItemEntries = [];
  num maxAmt = 0;


  @override
  Widget build(BuildContext context) {
    context.read<GraphProvider>().getGraphData();
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (_, state){
            if(state is ExpenseLoadedState){
              filterExpensesByYear(state.listExpenses);
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
      ),
    );
  }

  void filterExpensesByYear(List<ExpenseModel> listExpenses) {
    arrYearWiseExpenses.clear();
    List<String> arrUniqueYear = [];
    List<int> expID = [];
    int mCount=0;

    // Step-1 Unique Year add in String List
    for(ExpenseModel eachExp in listExpenses){

      var eachDate = DateTime.parse(eachExp.exp_time);
      var mYear = "${eachDate.year}";

      if(!arrUniqueYear.contains(mYear)){
        arrUniqueYear.add(mYear);
      }

    }

    // Step-2
    for(String eachUniqueYear in arrUniqueYear){
      mCount++;

      List<ExpenseModel> eachYearExpenses = [];
      num eachYearAmt = 0;

      for(ExpenseModel eachExp in listExpenses){

        if(eachExp.exp_time.contains(eachUniqueYear)){
          eachYearExpenses.add(eachExp);
          expID.add(eachExp.expe_cat_id);

          if (eachExp.exp_type == 0) {
            //debit
            eachYearAmt -= eachExp.exp_amt;
          } else {
            //credit
            eachYearAmt += eachExp.exp_amt;
          }

        }

      }

      num amt = eachYearAmt;

      if(amt<0){
        amt = num.parse(amt.toString().substring(1,(amt.toString().length)));
      }

      if(amt>maxAmt){
        maxAmt = amt;
      }

      arrYearWiseExpenses.add(FilteredExpenseModel(
          name: eachUniqueYear,
          totalAmt: eachYearAmt,
          arrExpenses: eachYearExpenses));

      if(mCount==5){
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
      Provider.of<GraphProvider>(context,listen: false).setGraphData(arrYearWiseExpenses);
      Provider.of<GraphProvider>(context,listen: false).setMaxAmount(maxAmt);
    });

  }

}
