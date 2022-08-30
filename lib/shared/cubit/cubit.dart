// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_task_screen.dart';
import 'package:todo_app/modules/done_tasks/done_task_screen.dart';
import 'package:todo_app/modules/new_tasks/new_task_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
 {
  AppCubit([aboutDialog]) : super(AppInitialState());
   static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
       const NewTaskScreen(),
       const DoneTaskScreen(),
       const ArchivedTaskScreen()
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavbar());
  }
 late Database database;
   List<Map> tasks = [];
   List<Map> newtasks = [];
   List<Map> donetasks = [];
   List<Map> archivedtasks = [];
   void createDatabase()  {
    openDatabase(
      'todo.db', 
       version: 1,
       onCreate: (database, version) {
       print('database created');

      database.execute( 'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT , status TEXT)')
          .catchError((error) {
        print('Error creating a table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDb(database);
    }).then((value) {
      database = value;
    });
  }
  void updateRecord(
    {
      required String status,
      required int id,
    }
   )async
   {
     database.rawUpdate(
     'UPDATE tasks SET status = ? WHERE id = ?',
     ['$status}', id]
    ).then((value) {
      emit(AppUpdateDatabaseState());
    });    
   }
   void deleteRecord(
    {
      required int id,
    }
   )async
   {
     database.rawDelete(
     'Delete FROM tasks WHERE id = ?',
     [id]
    ).then((value) {
      emit(AppDeleteDatabaseState());
    });    
   }
   insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date
  }) async{
    await database.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO tasks(title , date , time , status) VALUES($title" , "$date" ,"$time","new")')
          .then((value) {
        print('$value inserted successfully ');
        emit(AppInsertDatabaseState());
         getDataFromDb(database);
      }).catchError((error) {
        print('Error Inserting a new record ${error.toString()}');
      });
      return null;
    });
  }
  void getDataFromDb(database) async{
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {
        newtasks = [];
        donetasks = [];
        archivedtasks = [];
         value.forEach((element){
            if(element['status'] == 'new') {
              newtasks.add(element);
            }else if(element['status'] == 'done'){
              donetasks.add(element);
            }else{
              archivedtasks.add(element);
            }
         });
         getDataFromDb(database);
         emit(AppGetDatabaseState());
      });
  }
   var bottomSheetVisible = false;
   IconData fapIcon = Icons.edit;

   void setBottomSheetState({required bool isShow , required IconData icon})
   {
    bottomSheetVisible = isShow;
    fapIcon = icon;
    emit(AppChangeBottomSheetState());
   }
 }

