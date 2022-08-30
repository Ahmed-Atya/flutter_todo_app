import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model , context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction) {
    AppCubit.get(context).deleteRecord(id: model['id']);
  },
  child:Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children:  [
        CircleAvatar(
        radius: 40.0,
        child: Text('${model['time']}'),
      ),
      const SizedBox(
        width: 20.0,
      ),
        Expanded(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              '${model['title']}',
              style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold
              ),
            ),
                  Text(
             '${model['date']}',
              style: const TextStyle(
              color: Colors.grey
              ),
            ),
          ],
          ),
        ),
        const SizedBox(
        width: 20.0,
      ),

      IconButton(
        onPressed: (){
          AppCubit.get(context).updateRecord(status: 'done', id: model['id']);
        }, 

        icon: const Icon(
          Icons.check_box,
          color: Colors.green,
          )
        ),

        IconButton(
        onPressed: (){
          AppCubit.get(context).updateRecord(status: 'archived', id: model['id']);
        },
        icon: const Icon(
          Icons.archive,
          color: Colors.black38,
          )
        )
    ],
  ),
  ),
);