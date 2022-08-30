// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_web_libraries_in_flutter

// ignore: unused_import
import 'dart:js';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  // @override
  // void initState()  {
  //   super.initState();
  //   createDatabase();
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              builder: (BuildContext context) =>
                  cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
              condition: state is! AppGetDatabaseLoadingState,
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(
                  cubit.fapIcon,
                ),
                onPressed: () {
                  if (cubit.bottomSheetVisible) {
                    if (formKey.currentState!.validate()) {
                      cubit
                          .insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      )
                          .then((value) {
                        Navigator.pop(context);
                        cubit.getDataFromDb(cubit.database);
                      });
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            padding: const EdgeInsets.all(30.0),
                            color: Colors.red[200],
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return ('Title Must not be empty!');
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Task Title',
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 17,
                                          fontFamily: 'AvenirLight',
                                        ),
                                        prefixIcon: Icon(
                                          Icons.title,
                                          color: Colors.white60,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return ('Time Must not be empty!');
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Time OF Task',
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'AvenirLight',
                                        ),
                                        prefixIcon: Icon(
                                          Icons.time_to_leave_outlined,
                                          color: Colors.white60,
                                        )),
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return ('Date Must not be empty!');
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Date OF Task',
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'AvenirLight',
                                        ),
                                        prefixIcon: Icon(
                                          Icons.calendar_today,
                                          color: Colors.white60,
                                        )),
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-11-03'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.setBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });
                    cubit.setBottomSheetState(isShow: true, icon: Icons.add);
                  }
                }),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Recent Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle), label: 'Done Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.folder,
                    ),
                    label: 'Archived Tasks'),
              ],
            ),
          );
        },
      ),
    );
  }
}
