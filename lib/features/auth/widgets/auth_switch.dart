import 'package:flutter/material.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/pages/login_page.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/pages/sigin_up_page.dart';

class AuthSwitch extends StatefulWidget {
  const AuthSwitch({super.key, this.initialLogin = true});

  final bool initialLogin;

  @override
  State<AuthSwitch> createState() => _AuthSwitchState();
}

class _AuthSwitchState extends State<AuthSwitch> {
  late bool isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialLogin;
  }

  void switchAuth() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(onSwitch: switchAuth)
        : SiginUpPage(onSwitch: switchAuth);
  }
}
