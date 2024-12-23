import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/helpers/database_helper.dart';
import 'package:todo_sqlite/models/task_model.dart';
import 'package:todo_sqlite/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>>? _taskList;

  @override
  void initState() {
    _updateTaskList();
    super.initState();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()))),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedTaskCount = snapshot.data!
                .where((Task task) => task.status == 1)
                .toList()
                .length;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 80),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Tasks',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${completedTaskCount} of ${snapshot.data!.length}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                }
                return _buildTask(
                  index: snapshot.data![index - 1],
                );
              },
              itemCount: 1 + snapshot.data!.length,
            );
          }),
    );
  }
}

class _buildTask extends StatelessWidget {
  final Task index;
  const _buildTask({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
      final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Text(index.title!),
            subtitle: Text('${dateFormat.format(index.date!)} ${index.priority}'),
            trailing: Checkbox(
              onChanged: (value) {
                print(value);
              },
              value: true,
              activeColor: Theme.of(context).primaryColor,
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
