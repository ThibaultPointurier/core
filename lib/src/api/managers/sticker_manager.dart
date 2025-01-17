import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/sticker.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_ioc/ioc.dart';

class StickerManager extends CacheManager<Sticker>  {
  late final Guild guild;

  Future<Sticker?> create ({ required String name, required String description, required String tags, required String filename }) async {
    if (guild.features.contains(GuildFeature.verified) || guild.features.contains(GuildFeature.partnered)) {
      Response response = await ioc.use<DiscordApiHttpService>().post(url: "/guilds/${guild.id}/stickers")
        .payload({
          'name': name,
          'description': description,
          'tags': tags,
          'file': Helper.getPicture(filename)
        }).build();

      dynamic payload = jsonDecode(response.body);

      Sticker sticker = Sticker.from(payload);
      sticker.manager = this;

      cache.putIfAbsent(sticker.id, () => sticker);

      return sticker;
    }

    ioc.use<MineralCli>().console.warn('cancelled ${guild.name} guild does not have the ${GuildFeature.verified} or ${GuildFeature.partnered} feature.');
    return null;
  }

  Future<Map<Snowflake, Sticker>> sync () async {
    cache.clear();

    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: "/guilds/${guild.id}/stickers")
      .build();

    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Sticker sticker = Sticker.from(element);

      cache.putIfAbsent(sticker.id, () => sticker);
    }

    return cache;
  }

  Future<Sticker> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
        .get(url: '/guilds/${guild.id}/stickers/$id')
        .build();

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final Sticker sticker = Sticker.from(payload);

      cache.putIfAbsent(sticker.id, () => sticker);
      return sticker;
    }

    throw ApiException('Unable to fetch sticker with id #$id');
  }
}
