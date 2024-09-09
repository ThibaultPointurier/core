import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRolesUpdateEventHandler = FutureOr<void> Function(
    Role, Role, Server);

abstract class ServerRolesUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRoleUpdate;

  @override
  String? customId;

  FutureOr<void> handle(Role before, Role after, Server server);
}