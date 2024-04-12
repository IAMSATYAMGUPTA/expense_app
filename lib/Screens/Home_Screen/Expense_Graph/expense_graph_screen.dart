import 'package:expense_app/Custom_Widget/app_custom_widget.dart';
import 'package:expense_app/Screens/Home_Screen/Expense_Graph/month_expenses_page.dart';
import 'package:expense_app/Screens/Home_Screen/Expense_Graph/week_expenses_page.dart';
import 'package:expense_app/Screens/Home_Screen/Expense_Graph/year_expenses_page.dart';
import 'package:expense_app/Services/graph_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/filtered_expense_model.dart';

class ExpenseDetailsPage extends StatefulWidget {
  const ExpenseDetailsPage({Key? key}) : super(key: key);

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {

  List<FilteredExpenseModel> arrExpensesGraph = [];
  @override

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [

            //----------------show total amount----------------
            Expanded(
                flex: 2,
                child: Consumer<GraphProvider>(
                  builder: (context, value, child) {
                    num totalWeekAmount = 0;
                    value.graphData.forEach((element) {
                      totalWeekAmount = totalWeekAmount+element.totalAmt;
                    });
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$"+totalWeekAmount.toString(),style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.primary)),
                              Text("Total Spend This Week",style: TextStyle(color: Colors.grey.shade600,fontSize: 16),),
                            ],
                          ),

                        )
                      ],
                    );
                },)
            ),

            //----------------show graph-----------------------
            Expanded(
                flex: 3,
                child: Consumer<GraphProvider>(
                  builder: (context, value, child) {
                    num maxAmt = value.maxAmount ;
                    arrExpensesGraph = value.getGraphData();
                    return Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: LayoutBuilder(
                          builder: (_, constraint) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: arrExpensesGraph.map((e) {
                                num amt = e.totalAmt;
                                if(e.totalAmt<0){
                                  amt = num.parse(e.totalAmt.toString().substring(1,(amt.toString().length)));
                                }
                                if(amt<150){
                                  amt=150;
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 6),
                                      width: 30,
                                      height: constraint.maxHeight*((amt)/maxAmt)-30,
                                      decoration: BoxDecoration(
                                          color: e.totalAmt<0?Colors.red.shade300:Theme.of(context).colorScheme.primary,
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(11))
                                      ),
                                    ),
                                    hSpacer(height: 5),
                                    Text(e.name.toString(),style: TextStyle(fontSize: 14,color: Theme.of(context).colorScheme.primary),)
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
            ),
            hSpacer(height: 2),

            //--------Show total Entries using TabBar---------
            Expanded(
                flex: 5,
                child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        Material(
                          child: Container(
                            // padding: EdgeInsets.fromLTRB(22,10,22,0),
                            height: 50,
                            color: Theme.of(context).colorScheme.onSecondary,
                            child: TabBar(
                                indicator: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 7),
                                unselectedLabelColor: Colors.grey,
                                labelColor: Theme.of(context).colorScheme.primary,
                                tabs: [
                                  Tab(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border()
                                      ),
                                      child: Center(
                                        child: Text("Week",style: TextStyle(fontSize: 16),),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border()
                                      ),
                                      child: Center(
                                        child: Text("Month",style: TextStyle(fontSize: 16),),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border()
                                      ),
                                      child: Center(
                                          child: Text("Year",style: TextStyle(fontSize: 16),)
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),
                        Divider(color: Colors.blueGrey.shade300),
                        Expanded(
                            child: TabBarView(
                                children: [
                                  WeekExpensesPage(),
                                  MonthExpensesPage(),
                                  YearExpensesPage()
                                ]
                            )
                        ),
                      ],
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}
