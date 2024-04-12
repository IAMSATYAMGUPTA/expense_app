import '../App Database/db_helper.dart';

class ExpenseModel {
  int? exp_id;
  int? u_id;
  String exp_title;
  String exp_desc;
  num exp_amt;
  num exp_bal;
  int exp_type;
  int expe_cat_id;
  String exp_time;

  ExpenseModel({
    this.exp_id,
    this.u_id,
    required this.exp_title,
    required this.exp_desc,
    required this.exp_amt,
    required this.exp_bal,
    required this.exp_type,
    required this.expe_cat_id,
    required this.exp_time});

  factory ExpenseModel.fromMap(Map<String, dynamic> map) =>
      ExpenseModel(
          exp_id: map[DBHelper.EXPENSE_COLUMN_ID],
          u_id: map[DBHelper.USER_COLUMN_ID],
          exp_title: map[DBHelper.EXPENSE_COLUMN_TITLE],
          exp_desc: map[DBHelper.EXPENSE_COLUMN_DESC],
          exp_amt: map[DBHelper.EXPENSE_COLUMN_AMT],
          exp_bal: map[DBHelper.EXPENSE_COLUMN_BAL],
          exp_type: map[DBHelper.EXPENSE_COLUMN_TYPE],
          expe_cat_id: map[DBHelper.EXPENSE_COLUMN_CAT_ID],
          exp_time: map[DBHelper.EXPENSE_COLUMN_TIME]);


  Map<String, dynamic> toMap() =>
      {

        DBHelper.EXPENSE_COLUMN_ID: exp_id,
        DBHelper.USER_COLUMN_ID: u_id,
        DBHelper.EXPENSE_COLUMN_TITLE: exp_title,
        DBHelper.EXPENSE_COLUMN_DESC: exp_desc,
        DBHelper.EXPENSE_COLUMN_AMT: exp_amt,
        DBHelper.EXPENSE_COLUMN_BAL: exp_bal,
        DBHelper.EXPENSE_COLUMN_TYPE: exp_type,
        DBHelper.EXPENSE_COLUMN_CAT_ID: expe_cat_id,
        DBHelper.EXPENSE_COLUMN_TIME: exp_time,

      };}