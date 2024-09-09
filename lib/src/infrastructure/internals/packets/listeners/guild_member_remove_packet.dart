import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class GuildMemberRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberRemove;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberRemovePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server
        .getServer(message.payload['guild_id']);
    final memberId = message.payload['user']['id'];

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final memberCacheKey = marshaller.cacheKey.member(server.id, memberId);

    final user = await marshaller.dataStore.user.getUser(memberId);

    server.members.list.remove(memberId);

    final rawServer = await marshaller.serializers.server.deserialize(server);

    await marshaller.cache.put(serverCacheKey, rawServer);
    await marshaller.cache.remove(memberCacheKey);

    dispatch(event: Event.serverMemberRemove, params: [user, server]);
  }
}