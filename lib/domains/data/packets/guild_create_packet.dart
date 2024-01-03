import 'package:mineral/api/server/guild.dart';
import 'package:mineral/domains/data/internal_event_params.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.guildCreate;

  @override
  void listen(Map<String, dynamic> payload) {
    final {'message': ShardMessage message, 'dispatch': Function(InternalEventParams) dispatch} =
        payload;

    final guild = Guild.fromJson(message.payload);
    dispatch(InternalEventParams(event.toString(), [guild]));
  }
}