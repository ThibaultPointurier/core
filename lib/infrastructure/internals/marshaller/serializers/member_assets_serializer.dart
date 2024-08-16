import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class MemberAssetsSerializer implements SerializerContract<MemberAssets> {
  final MarshallerContract _marshaller;

  MemberAssetsSerializer(this._marshaller);

  @override
  Future<void> normalize(Map<String, dynamic> json) async {
    final payload = {
      'member_id': json['member_id'],
      'avatar': json['avatar'],
      'avatar_decoration': json['avatar_decoration_data']?['sku_id'],
      'banner': json['banner'],
    };

    final cacheKey = _marshaller.cacheKey.memberAssets(json['guild_id'], json['user']['id']);
    await _marshaller.cache.put(cacheKey, payload);
  }

  @override
  Future<MemberAssets> serialize(Map<String, dynamic> json) async {
    return MemberAssets(
      avatar: Helper.createOrNull(
          field: json['avatar'],
          fn: () => ImageAsset(['avatars', json['member_id']], json['avatar'])),
      avatarDecoration: Helper.createOrNull(
          field: json['avatar_decoration'],
          fn: () =>
              ImageAsset(['avatar-decorations', json['member_id']], json['avatar_decoration'])),
      banner: Helper.createOrNull(
          field: json['banner'],
          fn: () => ImageAsset(['banners', json['member_id']], json['banner'])),
      memberId: Snowflake(json['member_id']),
    );
  }

  @override
  Map<String, dynamic> deserialize(MemberAssets assets) {
    return {
      'member_id': assets.memberId.value,
      'avatar': assets.avatar?.hash,
      'avatar_decoration': assets.avatarDecoration?.hash,
      'banner': assets.banner?.hash,
    };
  }
}
