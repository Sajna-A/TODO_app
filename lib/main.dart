import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/BLOC/CUBIT/cubit/todo_task_cubit.dart';
import 'package:todo_app/SCREENS/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Required before database access
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoTaskCubit()..loadTasks(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
