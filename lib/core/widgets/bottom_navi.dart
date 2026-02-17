import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/core/network/dio_client.dart';
import 'package:lucidplus_machine_task/dependece_injection.dart';
import 'package:lucidplus_machine_task/features/profile/data/repository_impl.dart/profile_repository_impl.dart';
import 'package:lucidplus_machine_task/features/profile/data/source/profile_source.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/cubit/update_name_cubit.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/pages/profile_page.dart';
import 'package:lucidplus_machine_task/features/task/data/repository_impl/task_repo_impl.dart';
import 'package:lucidplus_machine_task/features/task/data/source/task_source.dart';
import 'package:lucidplus_machine_task/features/task/presentation/cubit/task_cubit.dart';
import 'package:lucidplus_machine_task/features/task/presentation/pages/task_page.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key, required this.name});

  final String name;

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int currentIndex = 0;
  late List<Widget> pages = [];

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    pages = [
      BlocProvider(
        create: (_) => TaskCubit(
          repository: TaskRepositoryImpl(TaskRemoteSourceImpl(DioClient())),
          userId: user.uid,
        )..fetchTasks(),
        child: TaskPage(userId: user!.uid),
      ),
      BlocProvider(
        create: (context) => UpdateNameCubit(
          ProfileRepositoryImpl(
            ProfileRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
          ),
        ),
        child: ProfilePage(name: widget.name),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBottomNav(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(80, 223, 223, 223),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withValues(alpha: 0.2),
          //   blurRadius: 10,
          //   offset: const Offset(0, 5),
          // ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_buildItem(Icons.task, 0), _buildItem(Icons.person, 1)],
      ),
    );
  }

  Widget _buildItem(IconData icon, int index, {String? label}) {
    final isSelected = widget.currentIndex == index;

    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate width
    final expandedWidth = screenWidth * 0.55;
    final collapsedWidth = 60.0;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        width: isSelected ? expandedWidth : collapsedWidth,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey),
            if (isSelected && label != null) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
