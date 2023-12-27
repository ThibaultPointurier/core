import 'dart:async';

import 'package:mineral/domains/events/events/ready_event.dart';
import 'package:mineral/domains/events/internal_event.dart';
import 'package:mineral/domains/kernel/types/mineral_client_contract.dart';

abstract interface class FunctionalEventRegistrarContract {
  void make(String event, Function() handle);

  void ready(FutureOr<void> Function() handle);
}

final class FunctionalEventRegistrar implements FunctionalEventRegistrarContract {
  final MineralClientContract _client;

  FunctionalEventRegistrar(this._client);

  @override
  void make(String event, Function() handle) => _registerEvent(InternalEvent(event, handle));

  @override
  void ready(FutureOr<void> Function() handle) => _registerEvent(InternalEvent('$ReadyEvent', handle));

  void _registerEvent(InternalEvent event) =>
      _client.kernel.eventManager.events.listen(event);
}