import 'dart:convert';

import 'package:smile_x/model/comment.dart';
import 'package:tuple/tuple.dart';

import '../request_manager.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/model/smile.dart';
import 'dart:typed_data';

class SmileAPI {
  // -------------------------------------//
  //  -- Initialize --
  //--------------------------------------//

  static final shared = SmileAPI._internal();

  factory SmileAPI() {
    return shared;
  }

  SmileAPI._internal();

  // -------------------------------------//
  //  -- API --
  //--------------------------------------//

  Future fetchSmiles(int userId) async {
    Map<String, dynamic> params = {'user_id': userId};
    await fetch('/smiles', params);
  }

  Future fetchSmile(int smileId) async {
    Map<String, dynamic> params = {'id': smileId};
    await fetch('/smiles/{$smileId}', params);
  }

  Future fetchUsersFor(int smileId) async {
    Map<String, dynamic> params = {'id': smileId};
    await fetch('/smiles/{$smileId}/users', params);
  }

  Future<Tuple2<bool, String>> postSmile(
    Uint8List smilePhotoBytes,
    Uint8List thumbnailPhotoBytes,
    List<int> groupIds,
    String caption,
    double lat,
    double lon,
  ) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    Map<String, dynamic> params = {
      'user_id': userId,
      'file': smilePhotoBytes != null ? base64.encode(smilePhotoBytes) : null,
      'backfile': base64.encode(thumbnailPhotoBytes),
      'theme_ids': groupIds.join(','),
      'caption': caption,
      'lat': lat,
      'lon': lon,
    };

    var result = await post('/smiles', params);
    if (!result.item2) {
      return Tuple2(false, result.item3);
    }
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> postSmileFor(
      int smileId, double degree, double lat, double lon,
      {Uint8List bytes}) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    Map<String, dynamic> params = {
      'user_id': userId,
      'lat': lat,
      'lon': lon,
      'degree': degree
    };
    final result = await post('/smiles/$smileId/otherpost', params);
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple3<List<Comment>, bool, String>> postCommentFor(
      int smileId, String text) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.tryParse(str);

    Map<String, dynamic> params = {
      'user_id': userId,
      'text': text,
    };

    final result = await post('/smiles/$smileId/comments', params);
    final smile = parseSmile(result.item1);
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(smile.comments, result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> postDiffDegreeFor(
      int smileId, double firstDegree, double maxDegree, double lat, double lon,
      {Uint8List bytes}) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    Map<String, dynamic> params = {
      'user_id': userId,
      'lat': lat,
      'lon': lon,
      'first_degree': firstDegree,
      'max_degree': maxDegree
    };
    final result = await post('/smiles/$smileId/diff_degree', params);
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> reportSmile(int smileId) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    Map<String, dynamic> params = {'id': smileId, 'user_id': userId};

    final result = await post('/smiles/$smileId/reports', params);
    return Tuple2(result.item2, result.item3);
  }
  // -------------------------------------//
  //  -- Parse --
  //--------------------------------------//

  List<Smile> parseSmiles(Map<String, dynamic> data) {
    final smiles = List<Map<String, dynamic>>.from(data['smiles']) ?? null;
    return smiles.map((json) {
      return Smile.createFrom(json);
    }).toList();
  }

  Smile parseSmile(Map<String, dynamic> data) {
    final smile = data.containsKey('smile')
        ? data['smile'] as Map<String, dynamic>
        : Map<String, dynamic>();
    return Smile.createFrom(smile);
  }

  Comment parseComment(Map<String, dynamic> data) {
    final json = data.containsKey('comment')
        ? cast<Map<String, dynamic>>(data['comment'])
        : null;
    return Comment.createFrom(json);
  }
}
