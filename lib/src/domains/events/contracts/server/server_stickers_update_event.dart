import 'dart:async';

import 'package:mineral/src/api/server/managers/sticker_manager.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerStickersUpdateEventHandler = FutureOr<void> Function(
    StickerManager, Server);

abstract class ServerStickersUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverStickersUpdate;

  @override
  String? customId;

  FutureOr<void> handle(StickerManager stickerManager, Server server);
}