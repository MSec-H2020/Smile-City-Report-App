import 'dart:convert';

import 'package:smile_x/controller/api/group_api.dart';
import 'package:smile_x/controller/api/point_api.dart';
import 'package:smile_x/controller/api/theme_api.dart';
import 'package:smile_x/model/group.dart';
import 'package:smile_x/model/invitation.dart';
import 'package:smile_x/model/point.dart';
import 'package:smile_x/model/theme.dart';

import '../request_manager.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'dart:typed_data';
import 'package:tuple/tuple.dart';

class UserAPI {
  // -------------------------------------//
  //  -- Initialize --
  //--------------------------------------//

  static final shared = UserAPI._internal();

  factory UserAPI() {
    return shared;
  }

  UserAPI._internal();

  // -------------------------------------//
  //  -- API --
  //--------------------------------------//

  Future<User> fetchMe() async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;
    final users = await fetchUsers(false, userId: userId);
    return users.item1.first;
  }

  Future<Tuple3<List<User>, bool, String>> fetchUsers(bool removeMe,
      {int userId, int facebookId, String email, String name}) async {
    Map<String, dynamic> params = {};
    if (userId != null) {
      params['id'] = userId;
    }

    final result = await fetch('/users', params);

    if (!result.item2) {
      return Tuple3(null, result.item2, result.item3);
    }
    if (result.item1 == null) {
      Tuple3([], result.item2, result.item3);
    }

    final users = parseUsers(result.item1);
    if (removeMe) {
      final str = await getPrefs(PrefsKey.UserId);
      final uId = int.parse(str) ?? 0;
      users.removeWhere((user) => user.id == uId);
    }
    return Tuple3(users, result.item2, result.item3);
  }

  Future<Tuple3<List<User>, bool, String>> fetchClassUsers(
      int classNum, bool removeMe) async {
    final result = await fetch('/users/class/$classNum', {});

    if (!result.item2) {
      return Tuple3(null, result.item2, result.item3);
    }
    if (result.item1 == null) {
      Tuple3([], result.item2, result.item3);
    }
    final users = parseUsers(result.item1);
    if (removeMe) {
      final userId = int.parse(await getPrefs(PrefsKey.UserId)) ?? 0;
      users.removeWhere((user) => user.id == userId);
    }

    return Tuple3(users, result.item2, result.item3);
  }

  Future<List<Group>> fetchGroups() async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    final result = await fetch('/users/$userId/groups', {});
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : GroupAPI.shared.parseGroups(result.item1);
  }

  Future<Tuple3<List<ReportTheme>, bool, String>> fetchThemes() async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    final result = await fetch('/users/$userId/themes_2', {});
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(ThemeAPI.shared.parseThemes(result.item1, ThemeType.all),
            result.item2, result.item3);
  }

  Future<Tuple3<List<Invitation>, bool, String>> fetchInvitations() async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    final result = await fetch('/users/$userId/invitations_2', {});
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(ThemeAPI.shared.parseInvitations(result.item1), result.item2,
            result.item3);
  }

  Future<Tuple3<PointSummary, bool, String>> fetchPointSummary() async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.tryParse(str) ?? 0;
    final result = await fetch('/users/$userId/points/summary', {});
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(PointAPI.shared.parsePointSummary(result.item1), result.item2,
            result.item3);
  }

  Future<Tuple3<User, bool, String>> postUser(String nickname, String password,
      String gender, int age, String area, String job, Uint8List bytes) async {
    Map<String, dynamic> params = {
      'nickname': nickname,
      'password': password,
      'gender': gender,
      'age': age,
      'area': area,
      'job': job,
      'file': base64.encode(bytes)
    };
    final result = await post('/users', params);
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(parseUser(result.item1), result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> postPoint(int pointId) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.tryParse(str) ?? 0;

    final result = await post('/users/$userId/points/$pointId', {});
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> updateProfile(Uint8List bytes) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;

    Map<String, dynamic> params = {'file': base64.encode(bytes)};
    final result = await post('/users/$userId/upd_profile', params);
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> addGroup(int groupId, List<int> userIds) async {
    final params = {'group_id': groupId, 'user_ids': userIds.join(',')};
    final result = await post('/users/add_group', params);
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> leave(int groupId, {int userId}) async {
    if (userId == null) {
      final str = await getPrefs(PrefsKey.UserId);
      userId = int.parse(str) ?? 0;
    }
    final result = await delete('/users/$userId/groups/$groupId/leave', {});
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple3<bool, User, String>> login(
      String nickname, String password) async {
    Map<String, dynamic> params = {
      'nickname': nickname,
      'password': password,
    };
    final result = await post('/users/login', params);
    if (result.item1 == null) {
      return Tuple3(false, null, 'Internal server error.');
    }
    return Tuple3(result.item1['login_success'], parseUser(result.item1), null);
  }

  Future<Tuple2<bool, String>> postAwareId(String awareId) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;
    Map<String, dynamic> params = {
      'aware_id': awareId,
    };

    final result = await post('/users/$userId/upd_aware_id', params);
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> blockUser(int blockUserId) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.parse(str) ?? 0;
    Map<String, dynamic> params = {
      'user_id': userId,
      'block_user_id': blockUserId,
    };

    final result = await post('/users/blocks', params);
    return Tuple2(result.item2, result.item3);
  }

  // -------------------------------------//
  //  -- Parse --
  //--------------------------------------//

  User parseUser(Map<String, dynamic> data) {
    final json = cast<Map<String, dynamic>>(data['user']);
    if (json != null) {
      return User.createFrom(json);
    } else {
      return null;
    }
  }

  List<User> parseUsers(Map<String, dynamic> data) {
    final users = data.containsKey('users')
        ? List<Map<String, dynamic>>.from(data['users'])
        : [];
    return users.map((json) {
      return User.createFrom(json);
    }).toList();
  }
}
