import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lucidplus_machine_task/core/network/domain/network_repo.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  @override
  Stream<NetworkStatus> get networkStatusStream =>
      InternetConnection().onStatusChange.map((status) {
        // debug log
        // ignore: avoid_print
        print('[NetworkRepositoryImpl] onStatusChange: $status');
        switch (status) {
          case InternetStatus.connected:
            return NetworkStatus.connected;
          case InternetStatus.disconnected:
            return NetworkStatus.disconnected;
        }
      });

  @override
  Future<NetworkStatus> getCurrentNetworkStatus() async {
    try {
      final status = await InternetConnection().onStatusChange.first;
      // debug log
      // ignore: avoid_print
      print('[NetworkRepositoryImpl] getCurrentNetworkStatus: $status');
      switch (status) {
        case InternetStatus.connected:
          return NetworkStatus.connected;
        case InternetStatus.disconnected:
          return NetworkStatus.disconnected;
      }
    } catch (_) {
      return NetworkStatus.disconnected;
    }
  }
}
