import 'package:flutter/material.dart';
import 'package:learn1/model/Task.dart';
import 'package:provider/provider.dart';

import '../provider/TaskModel.dart';

class ListTasksByTabKeyWidget extends StatelessWidget {
  final String tabKey;
  const ListTasksByTabKeyWidget({super.key, required this.tabKey});
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, task, child) {
        return ListView.builder(
          itemCount: task.todotasks[tabKey]!.length,
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
                  title: Text(task.todotasks[tabKey]![index].title),
                  leading: Checkbox(
                    value: task.todotasks[tabKey]![index].status,
                    onChanged: (bool? value) {
                      if (value!) {
                        Task taskToDelete = task.todotasks[tabKey]![index];
                        task.markAsChecked(index, value, tabKey);
                        Future.delayed(const Duration(seconds: 2),
                            () => task.markAsDone(taskToDelete, tabKey));
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
