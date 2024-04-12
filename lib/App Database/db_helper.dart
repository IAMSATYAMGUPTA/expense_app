import 'dart:io';

import 'package:expense_app/Model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/expense_model.dart';

class DBHelper extends Sqflite{

  DBHelper._();

  static final DBHelper db = DBHelper._();

  Database? database;

  // user
  static final USER_TABLE = "usrOnboarding";
  static final USER_ID = "id";
  static final USERNAME = "username";
  static final PASSWORD = "password";

  //expense
  static final EXPENSE_TABLE = "expense";
  static const EXPENSE_COLUMN_ID = "exp_id";
  static const USER_COLUMN_ID = "uid";
  static const EXPENSE_COLUMN_TITLE = "exp_title";
  static const EXPENSE_COLUMN_DESC = "exp_desc";
  static const EXPENSE_COLUMN_AMT = "exp_amt";
  static const EXPENSE_COLUMN_BAL = "exp_bal";
  static const EXPENSE_COLUMN_TYPE = "exp_type"; //0 -> debit & 1 -> Credit
  static const EXPENSE_COLUMN_CAT_ID = "exp_cat_id";
  static const EXPENSE_COLUMN_TIME = "exp_time";

  Future<Database> getDB()async{
    if(database!=null){
      return database!;
    }
    else{
      return await initDB();
    }
  }

  Future<Database> initDB()async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    var dbPath = join(documentDirectory.path,"userOnboarding.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {

        db.execute("""CREATE TABLE $USER_TABLE (
        $USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $USERNAME TEXT NOT NULL UNIQUE,
        $PASSWORD TEXT NOT NULL
        )""");

        db.execute(
            """Create table $EXPENSE_TABLE ( 
            $EXPENSE_COLUMN_ID integer primary key autoincrement, 
            $USER_COLUMN_ID integer, 
            $EXPENSE_COLUMN_TITLE text, 
            $EXPENSE_COLUMN_DESC text, 
            $EXPENSE_COLUMN_AMT real, 
            $EXPENSE_COLUMN_BAL real, 
            $EXPENSE_COLUMN_TYPE integer, 
            $EXPENSE_COLUMN_CAT_ID integer, 
            $EXPENSE_COLUMN_TIME String )""");
      },
    );
  }


  Future<bool> addUserDetail(UserModel userModel)async{

    var db = await getDB();

    try{
      var check = await db.insert(USER_TABLE, userModel.toMap());
      return check>0;
    }catch(e){
      return false;
    }

  }


  Future<bool> checkUserEmail(String userName)async{

    var db = await getDB();

    List<Map<String, dynamic>> result = await db.query(USER_TABLE, where: '$USERNAME = ?', whereArgs: [userName],);

    return result.isNotEmpty;
  }


  Future<bool> checkUserPassword(String password)async{

    var db = await getDB();

    List<Map<String, dynamic>> result = await db.query(USER_TABLE, where: '$PASSWORD = ?', whereArgs: [password],);

    return result.isNotEmpty;
  }

  void setCurrentUserID(userName,password)async{

    var db = await getDB();

    var data = await db.query(USER_TABLE, where: "$USERNAME = ? and $PASSWORD = ?", whereArgs: [userName, password]);

    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setInt("userID",int.parse(data[0]['id'].toString()));

  }


  /// Expense Table operations
  Future<bool> addExpense(ExpenseModel newExpense) async{
    var db = await getDB();

    var pref = await SharedPreferences.getInstance();
    int? uid = pref.getInt("userID");
    newExpense.u_id = uid;

    int check = await db.insert(EXPENSE_TABLE, newExpense.toMap());

    return check>0;
  }

  Future<List<ExpenseModel>> getAllExpensesOfUser() async{
    var db = await getDB();

    // get user ID
    var pref = await SharedPreferences.getInstance();
    int? uid = pref.getInt("userID");

    List<Map<String, dynamic>> data = await db.query(EXPENSE_TABLE, where: "$USER_COLUMN_ID = ?", whereArgs: ["$uid"]);

    List<ExpenseModel> listExpenses = [];

    for(Map<String, dynamic> eachExpense in data){
      listExpenses.add(ExpenseModel.fromMap(eachExpense));
    }

    return listExpenses;
  }

}