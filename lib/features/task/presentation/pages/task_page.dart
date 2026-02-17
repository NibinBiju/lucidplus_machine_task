import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/task/presentation/cubit/task_cubit.dart';

class TaskPage extends StatelessWidget {
  final String userId;
  const TaskPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return const TaskView();
  }
}

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<TaskCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !cubit.isFetching) {
      cubit.fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Tasks"), backgroundColor: primary),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          if (context.read<TaskCubit>().tasks.isEmpty) {
            return Center(child: Text("No Tasks Found"));
          }
          final tasks = context.read<TaskCubit>().tasks;

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<TaskCubit>().fetchTasks(refresh: true);
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return context.read<TaskCubit>().isFetching
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }

                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: task.isCompleted
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        task.isCompleted ? Icons.check : Icons.pending,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(task.title),
                    subtitle: Text(
                      "${task.category} • ${task.priority} • Due: ${task.dueDate.toLocal().toShortDateString()}",
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

extension DateFormatter on DateTime {
  String toShortDateString() => "$day/$month/$year";
}
