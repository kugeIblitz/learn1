import 'package:flutter/material.dart';
import 'package:learn1/provider/TaskModel.dart';
import 'package:learn1/view/AddTasksView.dart';
import 'package:learn1/view/ListTasksView.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListTasksView(),
      routes: {
        'AddTask': (context) => const AddTasksView(),
        'ListTask': (context) => const ListTasksView(),
      },
    );
  }
}
