import 'package:dartz/dartz.dart';
import 'package:lucidplus_machine_task/core/network/dio_client.dart';
import 'package:lucidplus_machine_task/features/tasks/data/model/task_model.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';

abstract class TaskRemoteSource {
  Future<List<TaskModel>> getTasks(String userId, int skip, int limit);
  Future<Either> addTask(String userId, TaskEntity task);
  Future<Either> updateTask(
    String userId,
    int taskId,
    Map<String, dynamic> data,
  );
}

class TaskRemoteSourceImpl implements TaskRemoteSource {
  final DioClient dioClient;

  TaskRemoteSourceImpl(this.dioClient);

  @override
  Future<List<TaskModel>> getTasks(String userId, int skip, int limit) async {
    final response = await dioClient.dio.get(
      '/tasks/',
      queryParameters: {'user_id': userId, 'skip': skip, 'limit': limit},
    );

    if (response.statusCode == 200) {
      final rawData = response.data as Map<String, dynamic>;

      final tasksList = rawData['data'] as List<dynamic>;

      return tasksList
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  @override
  Future<Either<String, String>> addTask(String userId, TaskEntity task) async {
    try {
      final response = await dioClient.dio.post(
        '/tasks/',
        queryParameters: {'user_id': userId},
        data: (task as TaskModel).toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Task Added Successfully");
      } else {
        return Left("Failed to create task");
      }
    } catch (e) {
      return Left("Failed to create task: ${e.toString()}");
    }
  }

  @override
  Future<Either> updateTask(
    String userId,
    int taskId,
    Map<String, dynamic> data,
  ) async {
    try {
      var returnedData = await dioClient.dio.put(
        '/tasks/$taskId',
        queryParameters: {'user_id': userId},
        data: data,
      );
      print("status message${returnedData.statusCode}");
      if (returnedData.statusCode == 200) {
        print("Successs");
        return Right("Success");
      } else {
        print("Failed");
        return Left("Failed");
      }
    } catch (e) {
      return Left(e);
    }
  }
}
