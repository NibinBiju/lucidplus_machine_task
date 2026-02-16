import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/auth_model.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_event.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_button.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.onSwitch});

  final VoidCallback onSwitch;
  final TextEditingController _emailTextEditController =
      TextEditingController();
  final TextEditingController _passwordTextEditController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "User Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              CustomTextField(
                textEditingController: _emailTextEditController,
                hintText: "Email",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                textEditingController: _passwordTextEditController,
                hintText: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 30),

              CustomButton(
                text: "Login",
                onTap: () {
                  context.read<AuthBloc>().add(
                    LoginRequested(
                      authModel: AuthModel(
                        email: _emailTextEditController.text.trim(),
                        password: _passwordTextEditController.text.trim(),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: onSwitch,
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
