import 'package:flutter/material.dart';
import 'package:learn1/model/Task.dart';
import 'package:learn1/provider/TaskModel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:learn1/library/Globals.dart' as globals;

class AddTasksView extends StatefulWidget {
  const AddTasksView({super.key});

  @override
  State<AddTasksView> createState() => _AddTasksViewState();
}

class _AddTasksViewState extends State<AddTasksView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, task, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Tasks"),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: TableCalendar(
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarFormat: CalendarFormat.week,
                      firstDay: DateTime.utc(2001, 11, 07),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, dateTime, events) {
                          return task.countTasksByDate(dateTime) > 0
                              ? Container(
                                  width: 20,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: globals.primaries[
                                        task.countTasksByDate(dateTime)],
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        task
                                            .countTasksByDate(dateTime)
                                            .toString()),
                                  ),
                                )
                              : Container();
                        },
                        selectedBuilder: (context, date, focusedDay) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _titleController,
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Input task title",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    maxLength: 500,
                    maxLines: 5,
                    minLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Input task Description (Optional)",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Task newTask = Task(_titleController.text, false,
                    _descriptionController.text, _focusedDay);
                task.add(newTask);
                task.addTaskToCache(newTask);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                Navigator.pushReplacementNamed(context, 'ListTask');
              }
            },
            child: const Icon(Icons.done),
          ),
        );
      },
    );
  }
}
