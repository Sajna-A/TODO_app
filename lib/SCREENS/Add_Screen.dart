import 'package:flutter/material.dart';
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
        "completed": "0",
      };

      if (widget.existingTask != null) {
        widget.todoTaskCubit.editTask(widget.existingTask!["id"], newTask);
      } else {
        widget.todoTaskCubit.addTask(newTask);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTask != null ? "Edit Task" : "Add Task"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
