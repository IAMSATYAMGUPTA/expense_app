import 'dart:ui';
import 'package:expense_app/Constant/app_constant.dart';
import 'package:expense_app/Custom_Widget/app_custom_widget.dart';
import 'package:expense_app/utills/my_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Model/expense_model.dart';
import 'bloc/expense_bloc.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  var selectedCatIndex = -1;

  var listCatType = ['Debit', 'Credit'];
  var selectedTransType = 'Debit';
  String expAmount="";

  var titleController = TextEditingController();
  var descController = TextEditingController();

  var expTitle;
  var expDesc;

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var mWidth = mediaQueryData.size.width;
    var mHeight = mediaQueryData.size.height;

    var doller = expAmount;
    if(expAmount.length>0){
      if(expAmount[expAmount.length-1]=='.'){
        doller = doller.substring(0,doller.length-1);
      }
    }
    var dollerAmount = doller==""? '0.00': '${double.parse(doller)/83.12}'.substring(0,5);

    var date = DateTime.now();
    var currentTime = DateFormat('h:mm a').format(date).toString();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: mediaQueryData.orientation==Orientation.portrait? mHeight-40:mWidth,
            child: Column(
              children: [

                // ------ Back Button And Title Heading ------
                Expanded(
                  flex: 2,
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,5,0,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel",style: Theme.of(context).textTheme.titleLarge,)),
                              TextButton(onPressed: (){}, child: Text("Expense",style: TextStyle(fontSize: 20),)),
                              wSpacer(width: 66,)
                            ],
                          ),
                        ),
                      ]
                  ),
                ),

                // ------ Show Amount Text ------
                Expanded(
                    flex: 12,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("\$"+dollerAmount,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.grey),),
                          hSpacer(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("₹",style: TextStyle(color: Colors.grey,fontSize: 25)),
                              Text(expAmount=="" ? "0":expAmount,
                                  style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.primary,decoration: TextDecoration.underline,)),
                            ],
                          )
                        ],
                      ),
                    )
                ),

                // ------ Manage Time,Title & Desc,Icons
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [

                        // set Date Title and Desc
                        Row(
                          children: [
                            wSpacer(),
                            Text("Today at ${currentTime}",style: TextStyle(color: Colors.grey.shade500),),
                            wSpacer(width: mWidth*0.07),
                            InkWell(
                                onTap: (){
                                  ShowAlertDialog();
                                },
                                child: Text("Add Note",style: TextStyle(color: Colors.grey.shade400),)),
                          ],
                        ),
                        hSpacer(),
                        Divider(height: 3,color: Theme.of(context).colorScheme.onInverseSurface),

                        // set icon name and save button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // manage credit or Debit
                            Row(
                              children: [
                                wSpacer(width: 15),
                                Icon(Icons.credit_card,color: Colors.black38,),
                                wSpacer(width: 5),
                                DropdownButton(
                                  value: selectedTransType,
                                  underline: SizedBox(),
                                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                                  items: listCatType.map((element) => DropdownMenuItem(
                                    child: Text(element),
                                    value: element,
                                  )).toList(),
                                  onChanged: (value) {
                                    selectedTransType = value!;
                                    setState(() {});
                                  },
                                )
                              ],
                            ),

                            // Manage Icon
                            InkWell(
                              onTap: (){
                                CustomBottomSheet();
                              },
                              child: Row(
                                children: [
                                  Image.asset(AppConstants.categories[selectedCatIndex<0?20:selectedCatIndex]['img'],width: 25,height: 25,),
                                  wSpacer(width: 7),
                                  Text(AppConstants.categories[selectedCatIndex<0?20:selectedCatIndex]['name'],
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),)
                                ],
                              ),
                            ),

                            // set Save button
                            Row(
                              children: [
                                SizedBox(
                                  width: 65,
                                  height: 28,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: expAmount.length>0? Theme.of(context).colorScheme.primary:Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                                      ),
                                      onPressed: expAmount.length>0?(){
                                        context.read<ExpenseBloc>().add(AddExpenseEvent(
                                            newExpense: ExpenseModel(
                                                exp_title: expTitle?? AppConstants.categories[selectedCatIndex==-1 ? 5:selectedCatIndex]['name'],
                                                exp_desc: expDesc?? currentTime,
                                                exp_amt: double.parse(expAmount),
                                                exp_bal: 0,
                                                exp_type: selectedTransType=="Debit" ? 0 : 1,
                                                expe_cat_id: AppConstants.categories[selectedCatIndex==-1 ? 5:selectedCatIndex]['id'],
                                                exp_time: DateTime.now().toString())));
                                        Navigator.pop(context);
                                      }:(){CustomToast().toastMessage(msg: "please Enter Amount");},
                                      child: Text("Save",style: TextStyle(color: expAmount.length>0? Theme.of(context).colorScheme.onSecondary:Colors.black38),)),
                                ),
                                wSpacer()
                              ],
                            ),

                          ],
                        ),
                        hSpacer(height: 2),
                        Divider(height: 0,color: Theme.of(context).colorScheme.onInverseSurface),
                      ],
                    )
                ),

                // ------ Make Manural KeyBoard ------
                Expanded(
                    flex: 9,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 2/1),
                      itemCount: AppConstants.calList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            setAmountValue(index);
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: index!=11?Text(
                              AppConstants.calList[index],
                              style: TextStyle(fontSize: 30, color: Colors.grey),
                            ):Icon(Icons.close,color: Colors.grey,),
                          ),
                        );
                      },
                    )
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  setAmountValue(int index){
    if(index==0){

      expAmount = expAmount+"7";

    }else if(index==1){

      expAmount = expAmount+"8";

    }else if(index==2){

      expAmount = expAmount+"9";

    }else if(index==3){

      expAmount = expAmount+"4";

    }else if(index==4){

      expAmount = expAmount+"5";

    }else if(index==5){

      expAmount = expAmount+"6";

    }else if(index==6){

      expAmount = expAmount+"1";

    }else if(index==7){

      expAmount = expAmount+"2";

    }else if(index==8){

      expAmount = expAmount+"3";

    }else if(index==9){

      if(expAmount.length>0){
        expAmount = expAmount+".";
      }

    }else if(index==10){

      if(expAmount.length>0){
        expAmount = expAmount+"0";
      }

    }else if(index==11){

      if(expAmount.length>0){
        var lastIndex = expAmount.length-1;
        expAmount = expAmount.substring(0,lastIndex);
      }

    }
    setState(() {});
  }

  CustomBottomSheet(){
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 240,
          color: Theme.of(context).colorScheme.inversePrimary,
          child: GridView.builder(
            itemCount: AppConstants.categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,mainAxisExtent: 105),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  selectedCatIndex = index;
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12,18,12,12),
                      child: Image.asset(
                        AppConstants.categories[index]['img'],
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Text(
                      AppConstants.categories[index]['name'],style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  ShowAlertDialog(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            content: SizedBox(
              height: 130,
              child: Column(
                children: [
                  // ------------------Use TextField to Write Title----------------
                  SizedBox(
                    height: 50,
                    child: TextField(
                        controller: titleController,
                        decoration: myDecoration(
                            mLabel: "Title"
                        )),
                  ),
                  hSpacer(),

                  // ------------------Use TextField to Write Desc----------------
                  SizedBox(
                    height: 50,
                    child: TextField(
                        controller: descController,
                        decoration: myDecoration(
                          mLabel: "Description....",
                        )),
                  ),
                  hSpacer(),
                ],
              ),
            ),
            actions: [
              RectangularButton(title: "Add", onTap: (){
                expTitle = titleController.text.toString();
                expDesc = descController.text.toString();
                Navigator.pop(context);
                if(expTitle.toString().isEmpty){
                  expTitle=null;
                }
                if(expDesc.toString().isEmpty){
                  expDesc=null;
                }
                titleController.clear();
                descController.clear();
              }),
              RectangularButton(title: "Cancel",mWidth: 80.0, onTap: (){
                Navigator.pop(context);
                titleController.clear();
                descController.clear();
              }),
            ],
          );
        },
    );
  }

  Widget RectangularButton({required String title,required VoidCallback onTap,double mWidth=70.0}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: mWidth,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary
        ),
        child: Center(child: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontSize: 16),)),
      ),
    );
  }

}
