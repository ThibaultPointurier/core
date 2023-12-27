import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/guild.dart';

final class GuildVoiceChannel implements GuildChannel {
  @override
  final String id;

  @override
  final String name;

  @override
  final int position;

  @override
  final String guildId;

  @override
  final Guild guild;

  GuildVoiceChannel({
    required this.id,
    required this.name,
    required this.position,
    required this.guildId,
    required this.guild,
  });
}