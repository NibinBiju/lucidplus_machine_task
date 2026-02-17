import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lucidplus_machine_task/core/network/cubit/network_cubit.dart';
import 'package:lucidplus_machine_task/core/theme/app_theme.dart';
import 'package:lucidplus_machine_task/dependece_injection.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/data/repository_impl.dart/profile_repository_impl.dart';
import 'package:lucidplus_machine_task/features/profile/data/source/profile_source.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_state.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/cubit/get_user_details_cubit.dart';
import 'package:lucidplus_machine_task/features/splash/presentation/pages/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DependenceInjection().dependenceInject();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(
            ProfileRepositoryImpl(
              ProfileRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
            ),
          ),
        ),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<NetworkCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isConnectedToInternet = false;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    _streamSubscription = InternetConnection().onStatusChange.listen((event) {
      print("Network event:$event");
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToInternet = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
        default:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<AuthBloc>()),
              BlocProvider(
                create: (context) => GetUserDetailsCubit(
                  ProfileRepositoryImpl(
                    ProfileRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
                  ),
                ),
              ),
            ],
            child: isConnectedToInternet
                ? const SplashPage()
                : Scaffold(body: Center(child: Text("No Internet"))),
          ),
        );
      },
    );
  }
}
