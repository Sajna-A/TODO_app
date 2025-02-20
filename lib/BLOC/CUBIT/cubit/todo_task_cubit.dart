import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/database_helper.dart';

part 'todo_task_state.dart';

class TodoTaskCubit extends Cubit<TodoTaskState> {
  TodoTaskCubit() : super(TodoTaskInitial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
  try {
    final tasks = await DatabaseHelper.instance.getTasks();
    emit(TodoTaskLoaded(tasks));
  } catch (e) {
    print("Error loading tasks: $e");
    emit(TodoTaskError("Failed to load tasks"));
  }
}



  Future<void> addTask(Map<String, dynamic> task) async {
    try {
      final newTask = {
        "title": task["title"]!,
        "description": task["description"]!,
        "completed": 0, // Default to incomplete
      };
      await DatabaseHelper.instance.insertTask(newTask);
      loadTasks();
    } catch (e) {
      emit(TodoTaskError("Failed to add task: $e"));
    }
  }

  Future<void> editTask(int id, Map<String, dynamic> updatedTask) async {
    try {
      final taskData = {
        "title": updatedTask["title"]!,
        "description": updatedTask["description"]!,
        "completed": updatedTask["completed"] is int
            ? updatedTask["completed"]
            : int.tryParse(updatedTask["completed"].toString()) ??
                0, // ✅ Fix type issue
      };
      await DatabaseHelper.instance.updateTask(id, taskData);
      loadTasks();
    } catch (e) {
      emit(TodoTaskError("Failed to update task: $e"));
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await DatabaseHelper.instance.deleteTask(id);
      loadTasks();
    } catch (e) {
      emit(TodoTaskError("Failed to delete task: $e"));
    }
  }
}
