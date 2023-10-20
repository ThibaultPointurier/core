import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/image.dart';
import 'package:mineral/api/common/resources/picture.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_builder.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_text_channel_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_voice_channel_contracts.dart';
import 'package:mineral/api/server/contracts/emoji_contracts.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';
import 'package:mineral/api/server/resources/content_filter_level.dart';
import 'package:mineral/api/server/resources/guild_features.dart';
import 'package:mineral/api/server/resources/locale.dart';
import 'package:mineral/api/server/resources/mfa_level.dart';
import 'package:mineral/api/server/resources/notification_level.dart';
import 'package:mineral/api/server/resources/nsfw_level.dart';
import 'package:mineral/api/server/resources/premium_tier.dart';
import 'package:mineral/api/server/resources/vanity.dart';
import 'package:mineral/api/server/resources/verification_level.dart';

abstract interface class GuildContract {
  abstract final Snowflake id;
  abstract final String label;
  abstract final String? description;
  abstract final Snowflake ownerId;

  abstract final CacheContract<GuildMemberContract> members;
  abstract final CacheContract<RoleContract> roles;
  abstract final CacheContract<GuildChannelContract> channels;
  abstract final CacheContract<EmojiContract> emojis;

  abstract final Picture? icon;
  abstract final Picture? banner;
  abstract final Picture? splash;

  abstract final Snowflake? rulesChannelId;
  abstract final Snowflake? publicUpdatesChannelId;
  abstract final Snowflake? safetyAlertsChannelId;
  abstract final Snowflake? systemChannelId;
  abstract final int? systemChannelFlags;

  abstract final bool? widgetEnabled;
  abstract final Snowflake? widgetChannelId;

  abstract final VerificationLevel verificationLevel;
  abstract final NotificationLevel defaultNotificationLevel;
  abstract final ContentFilterLevel explicitContentFilter;
  abstract final NsfwLevel nsfwLevel;
  abstract final MfaLevel mfaLevel;
  abstract final PremiumTier premiumTier;
  abstract final Locale preferredLocale;
  abstract final List<GuildFeature> features;
  abstract final Vanity? vanity;

  abstract final String? applicationId;
  abstract final int? maxPresences;
  abstract final int? maxMembers;
  abstract final int? premiumSubscriptionCount;
  abstract final int? maxVideoChannelUsers;
  abstract final int? maxStageVideoChannelUsers;
  abstract final int? approximateMemberCount;
  abstract final int? approximatePresenceCount;
  abstract final bool premiumProgressBarEnabled;

  GuildTextChannelContract? get systemChannel;
  GuildTextChannelContract? get publicUpdatesChannel;
  GuildTextChannelContract? get safetyAlertsChannel;
  GuildTextChannelContract? get widgetChannel;
  GuildTextChannelContract? get rulesChannel;
  GuildVoiceChannelContract? get afkChannel;
  GuildMemberContract get owner;

  Future<void> setName({ required String name });
  Future<void> setRegion({ required String region });
  Future<void> setVerificationLevel({ required VerificationLevel verificationLevel });
  Future<void> setDefaultNotificationLevel({ required NotificationLevel defaultNotificationLevel });
  Future<void> setExplicitContentFilter({ required ContentFilterLevel explicitContentFilter });
  Future<void> setNsfwLevel({ required NsfwLevel nsfwLevel });
  Future<void> setAfkChannel({ required GuildVoiceChannelContract channel });
  Future<void> setAfkTimeout({ required int timeout });
  Future<void> setIcon({ required Image icon });

  Future<void> update(GuildBuilder builder);
  Future<void> delete();

  Future<void> ban({ required GuildMemberContract member, int? deleteMessageDays, String? reason });
  Future<void> unban({ required Snowflake userId, String? reason });
  Future<void> kick({ required GuildMemberContract member, String? reason });
  Future<void> leave();
}