enum NetworkStatus { connected, disconnected }

abstract class NetworkRepository {
  Stream<NetworkStatus> get networkStatusStream;
}

class CheckNetworkStatus {
  final NetworkRepository repository;

  CheckNetworkStatus(this.repository);

  Stream<NetworkStatus> execute() {
    return repository.networkStatusStream;
  }
}
