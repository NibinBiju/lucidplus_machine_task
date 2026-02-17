enum NetworkStatus { connected, disconnected }

abstract class NetworkRepository {
  Stream<NetworkStatus> get networkStatusStream;

  /// Returns the current network status once.
  Future<NetworkStatus> getCurrentNetworkStatus();
}
