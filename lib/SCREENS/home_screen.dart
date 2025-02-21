import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/BLOC/CUBIT/cubit/todo_task_cubit.dart';
import 'package:todo_app/SCREENS/add_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _addNewTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          todoTaskCubit:
              BlocProvider.of<TodoTaskCubit>(context), // ✅ Pass cubit
        ),
      ),
    );

    if (result == true) {
      BlocProvider.of<TodoTaskCubit>(context).loadTasks();
      _showSnackbar(context, "Task added successfully!");
    }
  }

  void _editTask(
      BuildContext context, int id, Map<String, dynamic> task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          existingTask: task.map((key, value) =>
              MapEntry(key, value.toString())), // ✅ Convert type
          todoTaskCubit:
              BlocProvider.of<TodoTaskCubit>(context), // ✅ Pass cubit
        ),
      ),
    );

    if (result == true) {
      BlocProvider.of<TodoTaskCubit>(context).loadTasks();
      _showSnackbar(context, "Task updated successfully!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("To Do List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTask(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoTaskCubit, TodoTaskState>(
        builder: (context, state) {
          if (state is TodoTaskLoaded) {
            return state.tasks.isEmpty
                ? const Center(child: Text("No tasks added yet!"))
                : ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(4, 4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(task["title"] ?? ""),
                            subtitle: Text(task["description"] ?? ""),
                            leading: Checkbox(
                              value: task["completed"] == 1,
                              onChanged: (val) {
                                final updatedTask = {
                                  ...task,
                                  "completed": val! ? 1 : 0,
                                };
                                BlocProvider.of<TodoTaskCubit>(context)
                                    .editTask(task["id"], updatedTask);
                              },
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () =>
                                      _editTask(context, task["id"], task),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    BlocProvider.of<TodoTaskCubit>(context)
                                        .deleteTask(task["id"]);
                                    _showSnackbar(context, "Task deleted!");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
