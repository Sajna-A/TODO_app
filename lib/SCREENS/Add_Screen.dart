import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/BLOC/CUBIT/cubit/todo_task_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? existingTask;
  final TodoTaskCubit todoTaskCubit; // ✅ Add this parameter

  const AddTaskScreen({
    super.key,
    this.existingTask,
    required this.todoTaskCubit, // ✅ Mark it as required
  });

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      titleController.text = widget.existingTask!["title"];
      descriptionController.text = widget.existingTask!["description"];
    }
  }

  void _saveTask() {
    if (titleController.text.isNotEmpty) {
      final newTask = {
        "title": titleController.text,
        "description": descriptionController.text,
        "completed": "0", // Keeping as String (assuming database expects this)
      };

      if (widget.existingTask != null) {
        // ✅ Convert id to int before passing
        int taskId = int.tryParse(widget.existingTask!["id"].toString()) ?? 0;
        BlocProvider.of<TodoTaskCubit>(context).editTask(taskId, newTask);
      } else {
        BlocProvider.of<TodoTaskCubit>(context).addTask(newTask);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingTask != null ? "Edit Task" : "Add Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Title"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 15, 77, 127),
              ),
              onPressed: _saveTask,
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
