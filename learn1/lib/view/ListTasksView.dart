import 'package:flutter/material.dart';
import 'package:learn1/library/Globals.dart' as globals;

import '../widget/ListAllTasksWidget.dart';
import '../widget/ListTasksByTabKeyWidget.dart';

class ListTasksView extends StatefulWidget {
  const ListTasksView({super.key});

  @override
  State<ListTasksView> createState() => _ListTasksViewState();
}

class _ListTasksViewState extends State<ListTasksView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ToDo List"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Today"),
              Tab(text: "Tomorrow"),
              Tab(text: "This Week"),
              Tab(text: "Next Week"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListAllTasksWidget(),
            ListTasksByTabKeyWidget(tabKey: globals.today),
            ListTasksByTabKeyWidget(tabKey: globals.tomorrow),
            ListTasksByTabKeyWidget(tabKey: globals.thisWeek),
            ListTasksByTabKeyWidget(tabKey: globals.nextWeek),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'AddTask');
          },
        ),
      ),
    );
  }
}
