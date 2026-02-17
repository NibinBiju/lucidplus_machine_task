import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/core/widgets/app_snackbar.dart';
import 'package:lucidplus_machine_task/dependece_injection.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_event.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/auth_switch.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_event.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/cubit/update_name_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.name});

  final String name;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    super.initState();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();

    final user = FirebaseAuth.instance.currentUser;
    context.read<UpdateNameCubit>().updateName(
      userId: user!.uid,
      newName: name,
    );
  }

  void _logout() async {
    context.read<AuthBloc>().add(LogoutRequested());
    AppSnackBar.showSuccess(context, "Logout successfully");

    Future.delayed(const Duration(milliseconds: 800), () {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const AuthSwitch(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout_outlined)),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<UpdateNameCubit, UpdateNameState>(
          listener: (context, state) {
            if (state is UpdateNameFailed) {
              AppSnackBar.showError(context, state.message);
            }
            if (state is UpdateNameSuccess) {
              AppSnackBar.showSuccess(context, state.message);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Text("Name", style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name is required";
                        }
                        if (value.trim().length < 3) {
                          return "Minimum 3 characters required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.dark_mode_outlined),
                              SizedBox(width: 12),
                              Text("Dark Mode"),
                            ],
                          ),
                          Switch(
                            value:
                                context.watch<ThemeBloc>().state.themeMode ==
                                ThemeMode.dark,
                            onChanged: (value) {
                              final userId =
                                  FirebaseAuth.instance.currentUser!.uid;

                              context.read<ThemeBloc>().add(
                                ToggleThemeEvent(
                                  userId: userId,
                                  isDarkMode: value,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// save button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _saveProfile,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
