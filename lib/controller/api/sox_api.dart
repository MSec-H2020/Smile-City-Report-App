import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../preferences_manager.dart';
import '../request_manager.dart';

class SoxAPI {
  static final shared = SoxAPI._internal();

  factory SoxAPI() {
    return shared;
  }

  SoxAPI._internal();

  Future<Tuple2<bool, String>> postSmile(
    Uint8List backPhotoBytes,
    double smilingProbability,
    double lat,
    double lon,
  ) async {
    final userId = int.parse(await getPrefs(PrefsKey.UserId)) ?? 0;
    final marketPlaceUserName = await getPrefs(PrefsKey.MarketplaceUsername) ?? '';
    final marketPlaceUserPublicKey = await getPrefs(PrefsKey.MarketplacePublicKey) ?? '';
    final publishTimestamp= DateTime.now().toUtc().toIso8601String();

    Map<String, dynamic> params = {
      'user_id': userId,
      'back_photo': base64.encode(backPhotoBytes),
      'smiling_probability': smilingProbability,
      'lat': lat,
      'lng': lon,
      'user_name': marketPlaceUserName,
      'public_key': marketPlaceUserPublicKey,
      'publish_timestamp': publishTimestamp
    };

    var result =
        await soxpost('/publish', params, 'http://fiware-test.ht.sfc.keio.ac.jp:8080');

    return Tuple2(result.item2, result.item3);
  }
}
