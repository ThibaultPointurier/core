import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class NewsChannel extends TextChannel {
  NewsChannel(
    super.description,
    super.lastPinTime,
    super.rateLimit,
    super.threads,
    super.nsfw,
    super.webhooks,
    super.messages,
    super.lastMessageId,
    super.guildId,
    super.parentId,
    super.label,
    super.type,
    super.position,
    super.flags,
    super.permissions,
    super.id
  );

  /// Follow this by an webhook application
  Future<void> follow (Snowflake webhookId) async {
    if (type != ChannelType.guildNews) {
      Console.warn(message: 'Impossible to follow the channel $id as it is not an announcement channel');
      return;
    }

    Http http = ioc.singleton(Service.http);
    await http.post(url: '/channels/$id/followers', payload: {
      'webhook_channel_id': webhookId
    });
  }

  factory NewsChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return NewsChannel(
      payload['topic'],
      payload['last_pin_timestamp'],
      payload['rate_limit_per_user'],
      ThreadManager(payload['guild_id']) ,
      payload['nsfw'] ?? false,
      WebhookManager(payload['guild_id'], payload['id']),
      MessageManager(),
      payload['last_message_id'],
      payload['guild_id'],
      payload['parent_id'],
      payload['name'],
      payload['type'],
      payload['position'],
      payload['flags'],
      permissionOverwriteManager,
      payload['id']
    );
  }
}
