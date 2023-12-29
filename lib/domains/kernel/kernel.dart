import 'package:mineral/application/http/header.dart';
import 'package:mineral/application/http/http_client.dart';
import 'package:mineral/application/http/http_client_config.dart';
import 'package:mineral/domains/events/event_manager.dart';
import 'package:mineral/domains/events/packets/message_create_packet.dart';
import 'package:mineral/domains/events/packets/ready_packet.dart';
import 'package:mineral/domains/kernel/types/kernel_contract.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/sharding_config.dart';

final class Kernel implements KernelContract {
  @override
  final Map<int, Shard> shards = {};

  @override
  final ShardingConfigContract config;

  @override
  final HttpClientContract httpClient;

  @override
  final EventManagerContract eventManager;

  Kernel({required this.httpClient, required this.config, required this.eventManager}) {
    httpClient.config.headers.addAll([
      Header.authorization('Bot ${config.token}'),
    ]);
  }

  Future<Map<String, dynamic>> getWebsocketEndpoint() async {
    final response = await httpClient.get('/gateway/bot');
    return switch (response.statusCode) {
      200 => response.body,
      401 => throw Exception('This token is invalid or revocated !'),
      _ => throw Exception(response.body['message']),
    };
  }

  Future<void> init() async {
    final {'url': String endpoint, 'shards': int shardCount} = await getWebsocketEndpoint();

    for (int i = 0; i < (config.shardCount ?? shardCount); i++) {
      final shard = Shard(shardName: 'shard #$i', url: endpoint, kernel: this);
      shards.putIfAbsent(i, () => shard);

      await shard.init();
    }
  }

  factory Kernel.create(
      {required String token, required int intent, int httpVersion = 10, int shardVersion = 10}) {
    final http = HttpClient(
        config: HttpClientConfigImpl(baseUrl: 'https://discord.com/api/v$httpVersion', headers: {
      Header.userAgent('Mineral'),
      Header.contentType('application/json'),
    }));

    final shardConfig = ShardingConfig(token: token, intent: intent, version: shardVersion);

    final EventManager eventManager = EventManager()
      ..listenPacketClass(ReadyPacket())
      ..listenPacketClass(MessageCreatePacket());

    return Kernel(httpClient: http, config: shardConfig, eventManager: eventManager);
  }
}
