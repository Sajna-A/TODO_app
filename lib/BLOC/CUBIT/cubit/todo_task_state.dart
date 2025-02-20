part of 'todo_task_cubit.dart';

@immutable
abstract class TodoTaskState {}

class TodoTaskInitial extends TodoTaskState {}

class TodoTaskLoading extends TodoTaskState {}

class TodoTaskLoaded extends TodoTaskState {
  final List<Map<String, dynamic>> tasks;
  TodoTaskLoaded(this.tasks);
}

class TodoTaskError extends TodoTaskState {
  final String message;
  TodoTaskError(this.message);
}
