import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/core/dio_service/dio_client.dart';
import 'package:lucidplus_machine_task/core/widgets/app_snackbar.dart';
import 'package:lucidplus_machine_task/features/tasks/data/repository_impl/task_repo_impl.dart';
import 'package:lucidplus_machine_task/features/tasks/data/source/task_source.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/add_task_cubit.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/add_task_state.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/task_cubit.dart';

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

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddTaskBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search tasks...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) => context.read<TaskCubit>().searchTasks(value),
        ),
        backgroundColor: primary,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: FloatingActionButton(
          onPressed: () => _showAddTaskBottomSheet(context),
          backgroundColor: primary,
          child: const Icon(Icons.add),
        ),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          final cubit = context.read<TaskCubit>();

          if (state is TaskLoading && cubit.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          if (cubit.tasks.isEmpty) {
            return const Center(child: Text("No Tasks Found"));
          }

          final tasks = cubit.tasks;

          return RefreshIndicator(
            onRefresh: () async => await cubit.fetchTasks(refresh: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return cubit.isFetching
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
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
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

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'Low';
  String _category = 'Personal';
  DateTime _dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocProvider(
      create: (context) => AddTaskCubit(
        repository: TaskRepositoryImpl(TaskRemoteSourceImpl(DioClient())),
        userId: user!.uid,
      ),
      child: BlocConsumer<AddTaskCubit, AddTaskState>(
        listener: (context, state) {
          if (state is AddTaskSuccess) {
            try {
              context.read<TaskCubit>().fetchTasks(refresh: true);
            } catch (_) {
              final parentContext = Navigator.of(context).overlay?.context;
              if (parentContext != null) {
                try {
                  parentContext.read<TaskCubit>().fetchTasks(refresh: true);
                } catch (_) {}
              }
            }

            Navigator.pop(context);

            AppSnackBar.showSuccess(context, "Task added successfully");
          } else if (state is AddTaskFailed) {
            AppSnackBar.showSuccess(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: 12,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter title' : null,
                    ),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: _priority,
                          items: ['Low', 'Medium', 'High']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _priority = val);
                          },
                        ),
                        const SizedBox(width: 20),
                        DropdownButton<String>(
                          value: _category,
                          items: ['Personal', 'Work', 'Health']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _category = val);
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      title: Text(
                        'Due Date: ${_dueDate.toLocal().toShortDateString()}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _dueDate = picked);
                      },
                    ),
                    ElevatedButton(
                      onPressed: state is TaskLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AddTaskCubit>().addTask(
                                  TaskEntity(
                                    title: _titleController.text,

                                    isCompleted: false,
                                    dueDate: _dueDate,
                                    priority: _priority,
                                    category: _category,
                                  ),
                                );
                              }
                            },
                      child: state is TaskLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Add Task'),
                    ),
                  ],
                ),
              ),
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
