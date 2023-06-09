import 'package:flutter/material.dart';
import 'package:learn1/model/Task.dart';
import 'package:provider/provider.dart';
import 'package:learn1/library/Globals.dart' as globals;

import '../provider/TaskModel.dart';

class ListAllTasksWidget extends StatelessWidget {
  const ListAllTasksWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, task, child) {
        return ListView.builder(
          itemCount: task.todotasks.length,
          itemBuilder: (BuildContext context, int index) {
            String key = task.todotasks.keys.elementAt(index);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      globals.taskCategoryNames[key]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: task.todotasks[key]!.length,
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
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(task.todotasks[key]![index].title),
                            leading: Checkbox(
                              value: task.todotasks[key]![index].status,
                              onChanged: (bool? value) {
                                if (value!) {
                                  Task taskToDelete =
                                      task.todotasks[key]![index];
                                  task.markAsChecked(index, value, key);
                                  Future.delayed(const Duration(seconds: 2),
                                      () => task.markAsDone(taskToDelete, key));
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
