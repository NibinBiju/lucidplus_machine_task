import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/core/validator/field_validator.dart';
import 'package:lucidplus_machine_task/core/widgets/app_snackbar.dart';
import 'package:lucidplus_machine_task/dependece_injection.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/auth_model.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_event.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_state.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/auth_switch.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_button.dart';
import 'package:lucidplus_machine_task/features/auth/widgets/custom_text_field.dart';

class SiginUpPage extends StatefulWidget {
  const SiginUpPage({super.key, required this.onSwitch});

  final VoidCallback onSwitch;

  @override
  State<SiginUpPage> createState() => _SiginUpPageState();
}

class _SiginUpPageState extends State<SiginUpPage> {
  final TextEditingController _emailTextEditController =
      TextEditingController();

  final TextEditingController _passwordTextEditController =
      TextEditingController();

  final TextEditingController _nameTextEditController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextEditController.dispose();
    _passwordTextEditController.dispose();
    _nameTextEditController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const SizedBox(height: 20),

                  CustomTextField(
                    textEditingController: _nameTextEditController,
                    hintText: "Name",
                    icon: Icons.person,
                    isPassword: false,
                    validator: (value) => AppValidator.validateName(value),
                  ),
                  const SizedBox(height: 30),

                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        AppSnackBar.showError(context, state.message);
                      }
                      if (state is AuthAccountCreated) {
                        AppSnackBar.showSuccess(context, state.message);

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
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CustomButton(text: "Loading...", onTap: () {});
                      }

                      return CustomButton(
                        text: "Register",
                        onTap: () {
                          final isValid =
                              _globalKey.currentState?.validate() ?? false;

                          if (!isValid) return;
                          context.read<AuthBloc>().add(
                            SignUpRequested(
                              authModel: AuthModel(
                                email: _emailTextEditController.text.trim(),
                                password: _passwordTextEditController.text
                                    .trim(),
                                name: _nameTextEditController.text.trim(),
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
                      child: const Text("Already have an account? Log in"),
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
