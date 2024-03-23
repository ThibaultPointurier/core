import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerSerializer implements SerializerContract<Server> {
  final MarshallerContract _marshaller;

  ServerSerializer(this._marshaller);

  @override
  Future<Server> serialize(Map<String, dynamic> json, {bool cache = false}) async {
    final serializedRoles = await Future.wait(List.from(json['roles']).map((element) async => cache
        ? _marshaller.dataStore.server.getRole(Snowflake(json['id']), Snowflake(element['id']))
        : _marshaller.serializers.role.serialize(element)));

    final serializedMembers = await Future.wait(List.from(json['members']).map((element) async => cache
        ? _marshaller.dataStore.member.getMember(Snowflake(json['id']), Snowflake(element['id']))
        : _marshaller.serializers.member.serialize({...element, 'guild_roles': serializedRoles})));

    final channelManager =
        await ChannelManager.fromJson(marshaller: _marshaller, guildId: json['id'], json: json);

    final roleManager = RoleManager.fromList(serializedRoles);
    final owner = serializedMembers.firstWhere((member) => member.id == json['owner_id']);

    final server = Server(
      id: json['id'],
      name: json['name'],
      members: MemberManager.fromList(serializedMembers),
      settings: await _marshaller.serializers.serverSettings.serialize(json),
      roles: roleManager,
      channels: channelManager,
      description: json['description'],
      applicationId: json['application_id'],
      assets: await _marshaller.serializers.serversAsset
          .serialize({'guildRoles': serializedRoles, ...json}),
      owner: owner,
    );

    for (final channel in server.channels.list.values) {
      channel.server = server;
    }

    for (final member in server.members.list.values) {
      member.server = server;
    }

    return server;
  }

  @override
  Future<Map<String, dynamic>> deserialize(Server server) async {
    final assets = await _marshaller.serializers.serversAsset.deserialize(server.assets);
    return {
      'id': server.id,
      'name': server.name,
      'members': server.members.list.keys.toList(),
      'settings': await _marshaller.serializers.serverSettings.deserialize(server.settings),
      'roles': server.roles.list.keys.toList(),
      'channels': server.channels.list.keys.toList(),
      'description': server.description,
      'applicationId': server.applicationId,
      'assets': await _marshaller.serializers.serversAsset.deserialize(server.assets),
      'owner': await _marshaller.serializers.member.deserialize(server.owner),
      ...assets
    };
  }
}
