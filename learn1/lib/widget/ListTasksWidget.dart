import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn1/library/Globals.dart' as globals;

import '../provider/TaskModel.dart';

class ListTasksWidget extends StatelessWidget {
  const ListTasksWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, task, child) {
        return ListView.builder(
          itemCount: task.todotasks[globals.today]!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 123, 232, 126),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 123, 232, 126),
                ),
                child: CheckboxListTile(
                  title: Text(task.todotasks[globals.today]![index].title),
                  value: task.todotasks[globals.today]![index].status,
                  onChanged: (bool? value) {
                    task.MakeAsDone(index, value!, globals.today);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
