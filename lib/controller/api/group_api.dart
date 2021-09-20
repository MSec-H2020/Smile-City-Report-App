import 'dart:core';

import '../request_manager.dart';
import 'package:tuple/tuple.dart';

import 'package:smile_x/model/group.dart';
import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/controller/preferences_manager.dart';


class GroupAPI
{
  // -------------------------------------//
  //  -- Initialize --
  //--------------------------------------//

  static final shared = GroupAPI._internal();

  factory GroupAPI()
  {
    return shared;
  }

  GroupAPI._internal();


  // -------------------------------------//
  //  -- API --
  //--------------------------------------//

  Future<List<Group>> fetchGroups({int userId}) async
  {
    // For self
    if (userId == null) {
      final str = await getPrefs(PrefsKey.UserId);
      userId = int.parse(str) ?? 0;
    }
    // Fetch group ids
    Map<String, dynamic> params = {};
    final result = await fetch('/users/$userId/groups', params);
    return parseGroups(result.item1);

    // Fetch group members
    //params = {'group_id': 'group_id'};
    //await fetch('/groups/users', params);
  }

  Future<Group> fetchMembersIn(Group group) async
  {
    Map<String, dynamic> params = {'group_id': group.id};
    final result = await fetch('/groups/users', params);
    final users = UserAPI.shared.parseUsers(result.item1);
    group.members = users;
    return group;
  }


  Future fetchSmiles(int userId, int mode, int groupId) async
  {
    Map<String, dynamic> params = {'group_id': groupId};
    await fetch('/groups/smiles', params);
  }


  Future<Tuple2<bool, String>> postGroup(String name, List<int> userIds) async
  {
    // Create group
    Map<String, dynamic> params = {'group_name': name};
    var result = await post('/groups/create', params);
    if (!result.item2) {
      return Tuple2(false, result.item3);
    }

    // Parse group id
    final groupId = parseGroups(result.item1).first.id;
    if (groupId == null) {
      return Tuple2(false, 'failed parse');
    }

    // Add members to new group
    return UserAPI.shared.addGroup(groupId, userIds);
  }

  // -------------------------------------//
  //  -- Parse --
  //--------------------------------------//

  List<Group> parseGroups(Map<String, dynamic> data)
  {
    final groups = List<Map<String, dynamic>>.from(data['groups']) ?? [];
    return groups.map((json) {
      return Group.createFrom(json);
    }).toList();
  }
}