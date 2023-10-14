import 'package:mineral/api/common/client/application.dart';
import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/user/user.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class ReadyPacket implements PacketContract {
  @override
  Future<void> handle(WebsocketResponse response) async {
    final { 'application': application } = response.payload;

    final client = Client(
      version: response.payload['v'],
      user: User.fromWebsocket(response.payload['user']),
      application: Application(
        id: Snowflake(application['id']),
        flags: application['flags'],
      ),
      resumeGatewayUrl: response.payload['resume_gateway_url'],
      sessionId: response.payload['session_id'],
      sessionType: response.payload['session_type'],
    );

    container.bind<Client>('client', (_) => client);
  }
}