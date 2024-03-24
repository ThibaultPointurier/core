import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildMemberUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final Snowflake serverId = Snowflake(message.payload['guild_id']);
    final server = await marshaller.dataStore.server.getServer(serverId);

    final before = await marshaller.dataStore.member
        .getMember(guildId: serverId, memberId: Snowflake(message.payload['user']['id']));

    final after = await marshaller.serializers.member
        .serialize({...message.payload, 'guild_roles': server.roles.list});

    server.members.add(after);

    await marshaller.cache.put(server.id, await marshaller.serializers.server.deserialize(server));
    await marshaller.cache.put(after.id, await marshaller.serializers.member.deserialize(after));

    dispatch(event: MineralEvent.serverMemberUpdate, params: [before, after]);
  }
}
