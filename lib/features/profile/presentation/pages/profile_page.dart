import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_event.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isDarkMode = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();

    // TODO: Call Bloc / Provider to update profile
    debugPrint("Name: $name");
    debugPrint("Dark Mode: $_isDarkMode");
  }

  void _logout() {
    // TODO: Trigger logout from Bloc
    debugPrint("Logout clicked");
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// Name Field
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

                /// Dark Mode Switch
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
                          final userId = FirebaseAuth.instance.currentUser!.uid;

                          context.read<ThemeBloc>().add(
                            ToggleThemeEvent(userId: userId, isDarkMode: value),
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
        ),
      ),
    );
  }
}
