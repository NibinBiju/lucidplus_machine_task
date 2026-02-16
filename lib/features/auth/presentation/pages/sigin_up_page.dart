import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/auth_model.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_event.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_button.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_text_field.dart';

class SiginUpPage extends StatelessWidget {
  SiginUpPage({super.key, required this.onSwitch});

  final VoidCallback onSwitch;
  final TextEditingController _emailTextEditController =
      TextEditingController();
  final TextEditingController _passwordTextEditController =
      TextEditingController();
  final TextEditingController _nameTextEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 130),
                const Text(
                  "User Sign Up",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign up to continue",
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
                const SizedBox(height: 20),

                CustomTextField(
                  textEditingController: _nameTextEditController,
                  hintText: "Name",
                  icon: Icons.lock_outline,
                  isPassword: false,
                ),
                const SizedBox(height: 30),

                CustomButton(
                  text: "Register",
                  onTap: () {
                    context.read<AuthBloc>().add(
                      SignUpRequested(
                        authModel: AuthModel(
                          email: _emailTextEditController.text.trim(),
                          password: _passwordTextEditController.text.trim(),
                          name: _nameTextEditController.text.trim(),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: onSwitch,
                    child: const Text("Already have an account? Log in"),
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
