import 'package:mineral/src/domains/global_states/global_state.dart';

abstract interface class GlobalStateManagerContract {
  void register<T>(T state);
}

abstract interface class GlobalStateService {
  T read<T extends GlobalState>();
}

final class GlobalStateManager implements GlobalStateManagerContract, GlobalStateService {
  final Map<Type, dynamic> _providers = {};

  @override
  void register<T>(T state) => _providers[T] = state;

  @override
  T read<T extends GlobalState>() => _providers[T];
}