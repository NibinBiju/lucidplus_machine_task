import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:lucidplus_machine_task/core/network/domain/network_repo.dart';

class NetworkState {
  final bool isConnected;
  const NetworkState({required this.isConnected});
}

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkRepository repository;
  StreamSubscription? _subscription;

  NetworkCubit({required this.repository})
    : super(const NetworkState(isConnected: false)) {
    () async {
      try {
        final current = await repository.getCurrentNetworkStatus();

        print('[NetworkCubit] initial status: $current');
        emit(NetworkState(isConnected: current == NetworkStatus.connected));
      } catch (_) {}

      _subscription = repository.networkStatusStream.listen((status) {
        print('[NetworkCubit] onStatusChange: $status');
        emit(NetworkState(isConnected: status == NetworkStatus.connected));
      });
    }();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
