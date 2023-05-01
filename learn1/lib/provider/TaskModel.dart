import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn1/model/Task.dart';
import 'package:learn1/library/Globals.dart' as globals;
import 'package:dart_date/dart_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  TaskModel() {
    initState();
  }

  void initState() {
    loadTasksFromCache();
  }

  final List<Task> _doneTasks = [];
  final Map<String, List<Task>> _todotasks = {
    globals.late: [],
    globals.today: [],
    globals.tomorrow: [],
    globals.thisWeek: [],
    globals.nextWeek: [],
    globals.thisMonth: [],
    globals.later: [],
  };

  Map<String, List<Task>> get todotasks => _todotasks;
  List<Task> get doneTasks => doneTasks;

  void markAsChecked(int index, bool status, String key) {
    _todotasks[key]![index].status = status;
    notifyListeners();
  }

  void markAsDone(Task task, String key) {
    _doneTasks.add(task);
    syncDoneTasksToCache(task);
    _todotasks[key]!.removeWhere((e) => (e.id == task.id));
    print("done task${_doneTasks.map((e) => e.title)}");
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

  void addTaskToCache(Task task) async {
// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> tasksList = [];
    if (prefs.containsKey(globals.todoTasksKey)) {
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> oldTasks = json.decode(data!);
      tasksList = List<Task>.from(oldTasks.map((e) => Task.fromJson(e)));
      print(tasksList);
    }
    tasksList.add(task);
    await prefs.setString(globals.todoTasksKey, jsonEncode(tasksList));
  }

  void loadTasksFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(globals.todoTasksKey)) {
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> oldTasks = json.decode(data!);
      List<Task> tasksList =
          List<Task>.from(oldTasks.map((e) => Task.fromJson(e)));
      for (int i = 0; i < tasksList.length; i++) {
        add(tasksList[i]);
      }
    }
  }

  void syncDoneTasksToCache(Task task) async {
    //Retrieve all todoTasks
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Task> tasksList = await getCacheValuesByKey(globals.todoTasksKey);

    //remove from the list
    tasksList.removeWhere((element) => element.id == task.id);
    //update todo Tasks
    await prefs.setString(globals.todoTasksKey, jsonEncode(tasksList));

    //Retrieve all done tasks
    List<Task> doneList = await getCacheValuesByKey(globals.doneTasksKey);
    //add done task
    doneList.add(task);
    //update done tasks
    await prefs.setString(globals.doneTasksKey, jsonEncode(tasksList));
  }

  Future<List<Task>> getCacheValuesByKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> tasksList = [];
    if (prefs.containsKey(key)) {
      final String? data = prefs.getString(key);
      List<dynamic> oldTasks = json.decode(data!);
      return tasksList = List<Task>.from(oldTasks.map((e) => Task.fromJson(e)));
    }
    return [];
  }
}
