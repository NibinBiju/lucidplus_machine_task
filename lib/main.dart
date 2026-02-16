import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:lucidplus_machine_task/core/theme/app_theme.dart';
import 'package:lucidplus_machine_task/dependece_injection.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/data/repository_impl.dart/profile_repository_impl.dart';
import 'package:lucidplus_machine_task/features/profile/data/source/profile_source.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_state.dart';
import 'package:lucidplus_machine_task/features/splash/presentation/pages/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DependenceInjection().dependenceInject();

  runApp(
    BlocProvider(
      create: (context) => ThemeBloc(
        ProfileRepositoryImpl(
          ProfileRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
        ),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const SplashPage(),
          ),
        );
      },
    );
  }
}
