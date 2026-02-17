import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/core/network/dio_client.dart';
import 'package:lucidplus_machine_task/core/widgets/app_snackbar.dart';
import 'package:lucidplus_machine_task/features/tasks/data/repository_impl/task_repo_impl.dart';
import 'package:lucidplus_machine_task/features/tasks/data/source/task_source.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/add_task_cubit.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/add_task_state.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/update_task_cubit.dart';

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

  Future<void> _showAddTaskBottomSheet(
    BuildContext context,
    TaskEntity? task,
  ) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddTaskBottomSheet(task: task),
    );

    if (result == true) {
      try {
        context.read<TaskCubit>().fetchTasks(refresh: true);
      } catch (_) {}
    }
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
          onPressed: () => _showAddTaskBottomSheet(context, null),
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
                      onPressed: () => _showAddTaskBottomSheet(context, task),
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
  final TaskEntity? task;
  const AddTaskBottomSheet({super.key, this.task});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late String _priority;
  late String _category;
  late DateTime _dueDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();

    // Initialize fields for Add or Update
    _titleController = TextEditingController(text: widget.task?.title ?? '');

    _priority = widget.task?.priority ?? 'Low';
    _category = widget.task?.category ?? 'Personal';
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddTaskCubit(
            repository: TaskRepositoryImpl(TaskRemoteSourceImpl(DioClient())),
            userId: user!.uid,
          ),
        ),
        BlocProvider(
          create: (context) => UpdateTaskCubit(
            repository: TaskRepositoryImpl(TaskRemoteSourceImpl(DioClient())),
            userId: user!.uid,
          ),
        ),
      ],
      child: BlocConsumer<AddTaskCubit, AddTaskState>(
        listener: (context, state) {
          if (state is AddTaskSuccess) {
            // Return true to the parent so it can refresh tasks from its context
            Navigator.pop(context, true);
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
                          onChanged: (val) => setState(() => _priority = val!),
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
                          onChanged: (val) => setState(() => _category = val!),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _isCompleted,
                          onChanged: (val) =>
                              setState(() => _isCompleted = val!),
                        ),
                        const Text("Completed"),
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
                                final taskEntity = TaskEntity(
                                  id: widget.task?.id ?? 0,
                                  title: _titleController.text,
                                  priority: _priority,
                                  category: _category,
                                  isCompleted: _isCompleted,
                                  dueDate: _dueDate,
                                  createdDate:
                                      widget.task?.createdDate ??
                                      DateTime.now(),
                                );

                                if (widget.task != null) {
                                  // Update
                                  context
                                      .read<UpdateTaskCubit>()
                                      .updateTask(taskEntity)
                                      .then((_) {
                                        Navigator.pop(context, true);
                                        AppSnackBar.showSuccess(
                                          context,
                                          "Task updated successfully",
                                        );
                                      });
                                } else {
                                  // Add
                                  context.read<AddTaskCubit>().addTask(
                                    taskEntity,
                                  );
                                }
                              }
                            },
                      child: state is TaskLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.task != null ? 'Update Task' : 'Add Task',
                            ),
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
