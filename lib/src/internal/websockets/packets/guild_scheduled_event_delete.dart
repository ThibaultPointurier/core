import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildScheduledEventDelete with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = container.use<EventManager>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildScheduledEvent? event = guild?.scheduledEvents.cache.get(payload['id']);

    if (event != null) {
      guild?.scheduledEvents.cache.remove(event.id);
      eventManager.controller.add(GuildScheduledEventDeleteEvent(event));
    }
  }
}
