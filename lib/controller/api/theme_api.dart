import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:smile_x/model/invitation.dart';
import 'package:smile_x/model/smile.dart';
import 'package:smile_x/model/user.dart';

import '../request_manager.dart';
import '../preferences_manager.dart';
import 'package:tuple/tuple.dart';

import 'package:smile_x/model/theme.dart';

class ThemeAPI {
  // -------------------------------------//
  //  -- Initialize --
  //--------------------------------------//

  static final shared = ThemeAPI._internal();

  factory ThemeAPI() {
    return shared;
  }

  ThemeAPI._internal();

  // -------------------------------------//
  //  -- API --
  //--------------------------------------//

  // Future<Tuple3<List<ReportTheme>, bool, String>> fetchThemes(
  //     {int themeId}) async {
  //   Map<String, dynamic> params = {};
  //   final result = await fetch('/themes', params);
  //   return Tuple3(ThemeAPI.shared.parseThemes(result.item1, ThemeType.all),
  //       result.item2, result.item3);
  // }

  Future<Tuple2<bool, String>> postTheme(
      String title,
      List<int> userIds,
      String message,
      bool public,
      bool facing,
      bool ganonimize,
      Uint8List bytes,
      {int userId}) async {
    // For self
    if (userId == null) {
      final str = await getPrefs(PrefsKey.UserId);
      userId = int.parse(str) ?? 0;
    }

    // TODO: Add ganonymize
    // Create group
    Map<String, dynamic> params = {
      'title': title,
      'owner_id': userId.toString(),
      //'user_ids': userIds.join(','),
      'message': message,
      // 'area': area,
      'public': public,
      'facing': facing,
      'image_file': base64.encode(bytes),
      'isGanonymize': ganonimize,
    };
    var result = await post('/themes', params);
    if (result.item1 == null) {
      return Tuple2(false, result.item3);
    }
    final theme = parseTheme(result.item1);

    final r = await invite(theme.id, false, invited: userIds);
    return Tuple2(r.item2, r.item3);
  }

  Future<Tuple2<bool, String>> join(int themeId) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.tryParse(str) ?? 0;
    final params = {'user_id': userId};

    final result = await post('/themes/$themeId/join', params);
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> update(int themeId, {List<int> ids}) async {
    final params = {};
    if (ids != null) params['ids'] = ids.join(',');
    final result = await post('/themes/$themeId', params);
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple3<String, bool, String>> invite(int themeId, bool all,
      {List<int> invited}) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.tryParse(str) ?? 0;

    Map<String, dynamic> params = {
      'to_all': all,
      'inviter_id': userId,
    };
    if (!all) params['invited_ids'] = invited.join(',');
    final result = await post('/themes/$themeId/invite', params);
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(parseInvitationCode(result.item1), result.item2, result.item3);
  }

  Future<Tuple3<Invitation, bool, String>> fetchInvitation(String code) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.tryParse(str) ?? 0;

    final params = {'code': code, 'invited_id': userId};
    final result = await fetch('/invites/code', params);
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(parseInvitation(result.item1), result.item2, result.item3);
  }

  Future<Tuple2<bool, String>> accept(int invitationId) async {
    final result = await post('/invites/$invitationId', {});
    return Tuple2(result.item2, result.item3);
  }

  Future<Tuple3<User, bool, String>> fetchOwner(int themeId) async {
    final result = await fetch('/themes/$themeId/owner', {});
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(
            User.createFrom(result.item1['owner']), result.item2, result.item3);
  }

  Future<Tuple3<List<User>, bool, String>> fetchInvitedUsers(
      int themeId) async {
    final result = await fetch('/themes/$themeId/invited_users', {});
    final users = result.item1.containsKey('invited_users')
        ? List<Map<String, dynamic>>.from(result.item1['invited_users'])
        : [];
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(parseUsers(users), result.item2, result.item3);
  }

  Future<Tuple3<List<User>, bool, String>> fetchJoiningUsers(
      int themeId) async {
    final result = await fetch('/themes/$themeId/joining_users', {});
    final users = result.item1.containsKey('joining_users')
        ? List<Map<String, dynamic>>.from(result.item1['joining_users'])
        : [];
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(parseUsers(users), result.item2, result.item3);
  }

  Future<Tuple3<List<Smile>, bool, String>> fetchSmiles(int themeId) async {
    final str = await getPrefs(PrefsKey.UserId);
    final userId = int.tryParse(str) ?? 0;
    final params = {'user_id': userId};

    final result = await fetch('/themes/$themeId/smiles', params);
    final smiles = result.item1.containsKey('smiles')
        ? List<Map<String, dynamic>>.from(result.item1['smiles'])
        : [];
    return !result.item2
        ? Tuple3(null, result.item2, result.item3)
        : Tuple3(parseSmiles(smiles), result.item2, result.item3);
  }

  // -------------------------------------//
  //  -- Parse --
  //--------------------------------------//

  List<ReportTheme> parseThemes(Map<String, dynamic> data, ThemeType type) {
    final themes = List<Map<String, dynamic>>.from(data['themes']) ?? [];
    return themes.map((json) {
      return ReportTheme.createFrom(json);
    }).toList();
  }

  ReportTheme parseTheme(Map<String, dynamic> data) {
    final json = cast<Map<String, dynamic>>(data['theme']);
    return ReportTheme.createFrom(json);
  }

  Invitation parseInvitation(Map<String, dynamic> data) {
    final json = cast<Map<String, dynamic>>(data['invitation']);
    return Invitation.createFrom(json);
  }

  String parseInvitationCode(Map<String, dynamic> data) {
    return data['invitation_code'];
  }

  List<Invitation> parseInvitations(Map<String, dynamic> data) {
    final invitations =
        List<Map<String, dynamic>>.from(data['invitations']) ?? null;
    return invitations.map((json) => Invitation.createFrom(json)).toList();
  }

  List<User> parseUsers(List<Map<String, dynamic>> users) {
    return users.map((json) {
      return User.createFrom(json);
    }).toList();
  }

  List<Smile> parseSmiles(List<Map<String, dynamic>> smiles) {
    return smiles.map((json) {
      return Smile.createFrom(json);
    }).toList();
  }
}
