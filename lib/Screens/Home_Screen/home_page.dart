import 'package:expense_app/Custom_Widget/app_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import '../../Constant/app_constant.dart';
import '../../Model/expense_model.dart';
import '../../Model/filtered_expense_model.dart';
import 'Add Transection/add_transaction.dart';
import 'Add Transection/bloc/expense_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<FilteredExpenseModel> arrDateWiseExpenses = [];

  num totalExpAmt = 0;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchAllExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (_, state){
            if(state is ExpenseLoadedState){
              filterExpensesByDate(state.listExpenses);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    
                    // Add Transaction Button
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 40,
                          child: FloatingActionButton(

                            onPressed: (){
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.bottomToTop, child: AddTransaction(),duration: Duration(milliseconds: 800)));
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 190,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("All Expense Till Now",style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                            hSpacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,right: 4),
                                  child: Text("₹",style: TextStyle(color: Colors.grey,fontSize: 25)),
                                ),
                                Text(totalExpAmt.toString(),style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.primary)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(".50",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 25)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    ListView.builder(
                      padding: EdgeInsets.all(8),
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: arrDateWiseExpenses.length,
                      itemBuilder: (context, index) {
                        var currItem = arrDateWiseExpenses[index];
                        return Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.fromLTRB(65,40,15,0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${currItem.name}',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w800,fontSize: 16)),
                                      Text('${currItem.totalAmt>0 ? '+${currItem.totalAmt}':currItem.totalAmt}',
                                          style: TextStyle(color: currItem.totalAmt>0 ? Colors.green.shade400:Colors.red.shade300,
                                              fontWeight: FontWeight.bold,fontSize: 16))
                                    ],
                                  ),
                                  hSpacer(height: 6),
                                  Divider(color: Colors.blueGrey.shade300,height: 0),
                                ],
                              ),
                            ),

                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: currItem.arrExpenses.length,
                                itemBuilder: (_, childIndex){
                                  var currExp = currItem.arrExpenses[childIndex];
                                  var imgPath="";
                                  for(Map<String,dynamic> cat in AppConstants.categories){
                                    if(cat['id']==currExp.expe_cat_id){
                                      imgPath = cat['img'];
                                      break;
                                    }
                                  }
                                  return SizedBox(
                                    height: 60,
                                    child: ListTile(
                                      leading: Image.asset(imgPath,width: 40,height: 40,),
                                      title: Text(currExp.exp_title,style: TextStyle(fontWeight: FontWeight.w600),),
                                      subtitle: Text(currExp.exp_desc,style: TextStyle(color: Colors.grey),),
                                      trailing: Text('\$${currExp.exp_amt}',
                                        style: TextStyle(color: currExp.exp_type==0 ? Theme.of(context).colorScheme.primary:Colors.green,
                                            fontWeight: FontWeight.bold,fontSize: 16),
                                      ),
                                    ),
                                  );
                                }),

                          ],
                        );
                      },
                    ),
                  ],
                ),
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

  void filterExpensesByDate(List<ExpenseModel> arrExpenses){
    totalExpAmt = 0;
    arrDateWiseExpenses.clear();
    List<String> arrUniqueDates = [];


    /// step 1 (for unique dates)
    for (ExpenseModel eachExp in arrExpenses) {

      var eachDate = DateTime.parse(eachExp.exp_time);
      var mDate = "${eachDate.year}"
          "-${eachDate.month.toString().length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}"
          "-${eachDate.day.toString().length < 2 ? "0${eachDate.day}" : "${eachDate.day}"}";

      if (!arrUniqueDates.contains(mDate)) {
        arrUniqueDates.add(mDate);
      }

    }

    /// step 2 (unique dates expenses)
    for (String eachUniqueDate in arrUniqueDates) {

      List<ExpenseModel> eachDateExpenses = [];
      num eachDateAmt = 0;

      for (ExpenseModel eachExp in arrExpenses) {
        if(eachExp.exp_time.contains(eachUniqueDate)){
          eachDateExpenses.add(eachExp);

          if (eachExp.exp_type == 0) {
            //debit
            eachDateAmt -= eachExp.exp_amt;
          } else {
            //credit
            eachDateAmt += eachExp.exp_amt;
          }

        }

      }

      totalExpAmt += eachDateAmt;


      arrDateWiseExpenses.add(FilteredExpenseModel(
          name: eachUniqueDate,
          totalAmt: eachDateAmt,
          arrExpenses: eachDateExpenses
      ));

    }

  }


}
