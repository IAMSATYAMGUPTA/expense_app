import '../App Database/db_helper.dart';

class UserModel{
  int? id;
  String userName;
  String password;

  UserModel({this.id,required this.userName,required this.password});

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
        id: map[DBHelper.USER_ID],
        userName: map[DBHelper.USERNAME],
        password: map[DBHelper.PASSWORD]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      DBHelper.USER_ID: id,
      DBHelper.USERNAME: userName,
      DBHelper.PASSWORD: password,
    };
  }

}