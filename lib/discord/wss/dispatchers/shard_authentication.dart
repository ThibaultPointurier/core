import 'dart:async';
import 'dart:convert';

import 'package:mineral/api/wss/websocket_client.dart';
import 'package:mineral/discord/wss/builders/discord_message_builder.dart';
import 'package:mineral/discord/wss/constants/op_code.dart';
import 'package:mineral/discord/wss/sharding_config.dart';

abstract interface class ShardAuthentication {
  void setupRequirements(Map<String, dynamic> payload);

  void identify(Map<String, dynamic> payload);

  Future<void> connect();

  void reconnect();

  void ack();

  void resume();
}

final class ShardAuthenticationImpl implements ShardAuthentication {
  final WebsocketClient client;
  final ShardingConfig config;

  int? sequence;
  String? sessionId;
  String? resumeUrl;

  ShardAuthenticationImpl(this.client, this.config);

  @override
  void identify(Map<String, dynamic> payload) {
    createHeartbeatTimer(payload['heartbeat_interval']);

    final message = ShardMessageBuilder()
        .setOpCode(OpCode.identify)
        .append('token', config.token)
        .append('intents', 513)
        .append('compress', config.compress)
        .append('properties', {'\$os': 'macos', '\$device': 'mineral'});

    client.send(message.build());
  }

  void createHeartbeatTimer(int interval) {
    Timer.periodic(Duration(milliseconds: interval), (timer) {
      heartbeat();
    });
  }

  void heartbeat() {
    client.send(jsonEncode({
      'op': 1,
      'd': null,
    }));
  }

  @override
  void ack() {
    // print('Heartbeat ack !');
  }

  @override
  Future<void> connect() async {
    await client.connect();
  }

  @override
  void reconnect() {
    client.disconnect();
    connect();
  }

  @override
  void resume() {
    final message = ShardMessageBuilder()
        .setOpCode(OpCode.resume)
        .append('token', config.token)
        .append('session_id', sessionId)
        .append('seq', sequence);

    client.send(message.build());
  }

  @override
  void setupRequirements(Map<String, dynamic> payload) {
    sequence = payload['sequence'];
    sessionId = payload['session_id'];
    resumeUrl = payload['resume_gateway_url'];
  }
}