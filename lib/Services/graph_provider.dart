import 'package:expense_app/Model/filtered_expense_model.dart';
import 'package:flutter/material.dart';

class GraphProvider extends ChangeNotifier{

  List<FilteredExpenseModel> graphData = [];
  num maxAmount = 0;

  void setGraphData(List<FilteredExpenseModel> mData){
    graphData = mData;

    notifyListeners();
  }

  void setMaxAmount(num maxAmt){
    maxAmount = maxAmt;
    notifyListeners();
  }

  List<FilteredExpenseModel> getGraphData(){
    return graphData;
  }



}