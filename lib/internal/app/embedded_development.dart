import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_event_dispatcher.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/services/logger/logger_contract.dart';
import 'package:path/path.dart';

final class EmbeddedDevelopment implements EmbeddedApplication {
  final WebsocketEventDispatcher dispatcher = WebsocketEventDispatcher();
  final Queue<WebsocketResponse> eventQueue = Queue();
  final String debugName = 'embedded_application';
  final LoggerContract _logger;


  ReceivePort? _port;
  Isolate? isolate;

  EmbeddedDevelopment(this._logger);

  Future<void> create () async {
    final Uri mainUri = Uri.parse(join(Directory.current.path, 'bin', 'app.dart'));

    _port = ReceivePort();
    isolate = await Isolate.spawnUri(mainUri, [], _port!.sendPort, debugName: debugName);

    _logger.info('Kernel is ready');
  }

  Future<void> createAndListen () async {
    await create();
    await for (final WebsocketResponse message in _port!) {
      eventQueue.addLast(message);
      dispatcher.dispatch(message);
    }
  }

  void restoreEvents () {
    final queue = Queue<WebsocketResponse>.from(eventQueue);

    while (queue.isNotEmpty) {
      dispatch(queue.removeFirst());
    }
  }

  void kill () {
    _port?.close();
    isolate?.kill(priority: Isolate.immediate);
  }

  void restart () {
    kill();
    createAndListen();
    restoreEvents();
  }

  @override
  void dispatch(WebsocketResponse response) {
    _port?.sendPort.send(response);
  }
}