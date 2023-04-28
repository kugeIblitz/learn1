import 'package:flutter/material.dart';
import 'package:learn1/model/Task.dart';
import 'package:learn1/library/Globals.dart' as globals;
import 'package:dart_date/dart_date.dart';

class TaskModel extends ChangeNotifier {
  final Map<String, List<Task>> _todotasks = {
    globals.late: [Task("Task 1", false, "Hello task 1", DateTime.now())],
    globals.today: [Task("Task 1", false, "Hello task 1", DateTime.now())],
    globals.tomorrow: [Task("Task 1", false, "Hello task 1", DateTime.now())],
    globals.thisWeek: [Task("Task 1", false, "Hello task 1", DateTime.now())],
    globals.nextWeek: [Task("Task 1", false, "Hello task 1", DateTime.now())],
    globals.thisMonth: [Task("Task 1", false, "Hello task 1", DateTime.now())],
    globals.later: [Task("Task 1", false, "Hello task 1", DateTime.now())],
  };

  Map<String, List<Task>> get todotasks => _todotasks;

  void MakeAsDone(int index, bool status, String key) {
    _todotasks[key]![index].status = status;
    notifyListeners();
  }

  void add(Task task) {
    String key = guessToDoDayFromDate(task.deadline);
    if (todotasks.containsKey(key)) {
      _todotasks[key]!.add(task);
      notifyListeners();
    }
  }

  int countTasksByDate(DateTime datetime) {
    String key = guessToDoDayFromDate(datetime);
    if (todotasks.containsKey(key)) {
      _todotasks[key]!
          .where((task) =>
              task.deadline.day == datetime.day &&
              task.deadline.month == datetime.month &&
              task.deadline.year == datetime.year)
          .length;
    }
    return 0;
  }

  String guessToDoDayFromDate(DateTime deadline) {
    if (deadline.isPast && !deadline.isToday) {
      return globals.late;
    } else if (deadline.isToday) {
      return globals.today;
    } else if (deadline.isTomorrow) {
      return globals.tomorrow;
    } else if (deadline.getWeek == DateTime.now().getWeek) {
      return globals.thisWeek;
    } else if (deadline.getWeek == DateTime.now().getWeek + 1 &&
        deadline.isThisYear) {
      return globals.nextWeek;
    } else if (deadline.isThisMonth) {
      return globals.thisMonth;
    } else {
      return globals.later;
    }
  }
}
