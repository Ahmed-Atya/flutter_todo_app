// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class NewTaskScreen extends StatelessWidget {

   const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer <AppCubit , AppStates>(
      listener: (context, state) {},
      builder: (context , state) {
        var tasks = AppCubit.get(context).newtasks;
        return ListView.separated(
        itemBuilder: (context , index) => buildTaskItem(tasks[index] , context),
        separatorBuilder: (context,index) => Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
        itemCount: 6);
      }, 
   
    );
  }
}
