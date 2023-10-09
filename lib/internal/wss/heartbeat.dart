import 'dart:async';

import 'package:mineral/internal/wss/shard.dart';

final class Heartbeat {
  final Shard _shard;
  Duration? _delay;
  Timer? _timer;
  int ackMissing = 0;

  Heartbeat(this._shard);

  void beat (Duration delay) {
    _delay = delay;
    _timer = Timer.periodic(delay, (_) => _send());
  }

  void _cancel () {
    _timer?.cancel();
    ackMissing = 0;
  }

  void reset () {
    _cancel();

    if (_delay != null) {
      _timer = Timer.periodic(_delay!, (_) => _send());
    }
  }

  void _send() {
    _shard.send();
    _shard.lastHeartbeat = DateTime.now();
  }
}