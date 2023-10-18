import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/factories/contracts/event_contract.dart';

abstract interface class GuildCreateEventContract implements EventContract {
  Future<void> handle (GuildContract guild);
}