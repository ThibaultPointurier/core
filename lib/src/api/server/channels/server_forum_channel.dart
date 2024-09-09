import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/channel_properties.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/server/channels/server_category_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/enums/forum_layout_types.dart';
import 'package:mineral/src/api/server/enums/sort_order_forum.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/api/server/server.dart';

final class ServerForumChannel extends ServerChannel {
  final ChannelProperties _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  int get position => _properties.position!;

  @override
  ThreadsManager get threads => _properties.threads;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  String? get description => _properties.description;

  Snowflake? get categoryId => _properties.categoryId;

  final SortOrderType? sortOrder;

  final ForumLayoutType? layoutType;

  late final ServerCategoryChannel? category;

  @override
  Snowflake get serverId => _properties.serverId!;

  @override
  late final Server server;

  ServerForumChannel(this._properties,
      {required this.sortOrder, required this.layoutType});
}