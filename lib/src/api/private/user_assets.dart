import 'package:mineral/src/api/common/image_asset.dart';
import 'package:mineral/src/api/common/snowflake.dart';

final class UserAssets {
  final Snowflake userId;
  final ImageAsset? avatar;
  final ImageAsset? avatarDecoration;
  final ImageAsset? banner;

  UserAssets({
    required this.userId,
    required this.avatar,
    required this.avatarDecoration,
    required this.banner,
  });
}