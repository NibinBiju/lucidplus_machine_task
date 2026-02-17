import 'package:lucidplus_machine_task/core/network/dio_client.dart';
import 'package:lucidplus_machine_task/features/task/data/model/task_model.dart';

abstract class TaskRemoteSource {
  Future<List<TaskModel>> getTasks(String userId, int skip, int limit);
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
      print("DATA GOT:${response.data}");
      final rawData = response.data as Map<String, dynamic>;

      final tasksList = rawData['data'] as List<dynamic>;
      print("DATA GOT:$tasksList");

      return tasksList
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }
}
