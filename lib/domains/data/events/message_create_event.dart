import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerMessageEventHandler = FutureOr<void> Function(ServerMessage message);
typedef PrivateMessageEventHandler = FutureOr<void> Function(PrivateMessage message);

abstract class ServerCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverCreate;

  FutureOr<void> handle();
}
