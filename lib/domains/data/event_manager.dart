import 'package:mineral/domains/data/dispatchers/event_dispatcher.dart';
import 'package:mineral/domains/data/dispatchers/packet_dispatcher.dart';
import 'package:mineral/domains/data/types/listenable_dispatcher.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';

abstract interface class EventManagerContract {
  ListenableDispatcher get packets;

  ListenableDispatcher get events;

  void dispose();
}

final class EventManager implements EventManagerContract {
  @override
  late final PacketDispatcher packets;

  @override
  final EventDispatcher events = EventDispatcher();

  EventManager() {
    packets = PacketDispatcher(this);
  }

  void listenPacketClass(ListenablePacket packet) => packets.listen({'packet': packet.event, 'listener': packet.listen});

  @override
  void dispose() {
    packets.dispose();
    events.dispose();
  }
}