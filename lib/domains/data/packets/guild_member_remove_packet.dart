import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildMemberRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberRemove;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberRemovePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final Snowflake serverId = message.payload['guild_id'];
    final server = await marshaller.dataStore.server.getServer(serverId);
    final member = await marshaller.dataStore.member.getMember(
        guildId: serverId, memberId: Snowflake(message.payload['user']['id']));

    server.members.list.remove(member.id);
    await marshaller.cache.remove(member.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverMemberRemove, params: [member, server]);
  }
}
