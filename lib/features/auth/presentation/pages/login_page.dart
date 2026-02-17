import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/core/validator/field_validator.dart';
import 'package:lucidplus_machine_task/core/widgets/app_snackbar.dart';
import 'package:lucidplus_machine_task/core/widgets/bottom_navi.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/auth_model.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_event.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_state.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_button.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_text_field.dart';

import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onSwitch});

  final VoidCallback onSwitch;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextEditController =
      TextEditingController();

  final TextEditingController _passwordTextEditController =
      TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextEditController.dispose();
    _passwordTextEditController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),
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
                    validator: (value) => AppValidator.validateEmail(value),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    textEditingController: _passwordTextEditController,
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) => AppValidator.validatePassword(value),
                  ),
                  const SizedBox(height: 30),

                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        AppSnackBar.showError(context, state.message);
                      }
                      if (state is AuthAuthenticated) {
                        AppSnackBar.showSuccess(
                          context,
                          "Logged in successfully",
                        );
                        context.read<ThemeBloc>().add(
                          LoadThemeEvent(state.user.uid),
                        );

                        if (!context.mounted) return;
                        Future.delayed(const Duration(milliseconds: 800), () {
                          return Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationWidget(name: state.user.name),
                            ),
                          );
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CustomButton(text: "Loading...", onTap: () {});
                      }
                      return CustomButton(
                        text: "Login",
                        onTap: () {
                          final isValid =
                              _globalKey.currentState?.validate() ?? false;

                          if (!isValid) return;
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              authModel: AuthModel(
                                email: _emailTextEditController.text.trim(),
                                password: _passwordTextEditController.text
                                    .trim(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: widget.onSwitch,
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
