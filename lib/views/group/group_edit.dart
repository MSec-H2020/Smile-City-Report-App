//import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:smile_x/utils/utils.dart';
//import 'package:smile_x/controller/api/user_api.dart';
//import 'package:smile_x/model/user.dart';
//import 'package:smile_x/model/group.dart';
//
//
//class GroupEditController extends StatefulWidget
//{
//  final Group group;
//
//  @override
//  State<StatefulWidget> createState() => GroupEditControllerState();
//
//  GroupEditController(this.group);
//}
//
//class GroupEditControllerState extends State<GroupEditController>
//{
//  // Property
//  Group _group;
//  List<User> _friends = [];
//  bool _editing = false;
//  List<int> _selectedFriendIds = [];
//
//
//  @override
//  void initState()
//  {
//    // Invoke super
//    super.initState();
//
//    setState(() {
//      _group = widget.group;
//    });
//
//
//    UserAPI.shared.fetchUsers().then((users) {
//      final userIds = _group.members.map((user) => user.id);
//      setState(() {
//        // Filter members
//        _friends = users.where((user) => !userIds.contains(user.id)).toList();
//      });
//    });
//  }
//
//  void _updateAction(BuildContext context)
//  {
//    if (_selectedFriendIds.length == 0) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text('choose new group members'),
//      ));
//      return;
//    }
//
//    UserAPI.shared.addGroup(_group.id, _selectedFriendIds).then((result) {
//      if (!result.item1) {
//        print(result.item2);
//        return;
//      }
//
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text('successfully updated'),
//      ));
//
//      Navigator.of(context).pop(GroupStatus.update);
//    });
//  }
//
//  void _editAction()
//  {
//    setState(() {
//      _editing = !_editing;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(_group.name),
//        actions: _editing ? [_updateButton()] : [],
//      ),
//      body: _listView(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _editAction,
//        child: _editing ? Icon(Icons.cancel) : Icon(Icons.add),
//      ),
//    );
//  }
//
//  Widget _updateButton()
//  {
//    return Builder(
//      builder: (context) {
//        return IconButton(
//          icon: Icon(Icons.share),
//          onPressed: () => _updateAction(context),
//        );
//      },
//    );
//  }
//
//  Widget _listView()
//  {
//    return ListView.builder(
//      itemBuilder: (context, index) {
//        // For users
//        if (index < _group.members.length) {
//          final user = _group.members[index];
//          return ListTile(
//            leading: CircleAvatar(
//              backgroundImage: CachedNetworkImageProvider(user.iconUrl),
//            ),
//            title: Text(user.name),
//          );
//        }
//        // For header when editing
//        else if (index == _group.members.length) {
//          return ListTile(
//            leading: Text('Your friends'),
//          );
//        }
//        // For friends when editing
//        else if (index > _group.members.length) {
//          final friend = _friends[index - _group.members.length - 1];
//          return CheckboxListTile(
//              value: _selectedFriendIds.indexOf(friend.id) >= 0,
//              title: Row(
//                children: <Widget>[
//                  CircleAvatar(
//                    backgroundImage: CachedNetworkImageProvider(friend.iconUrl),
//                  ),
//                  Container(
//                    margin: EdgeInsets.only(left: 10),
//                    child: Text(friend.name,)
//                  )
//                ],
//              ),
//              onChanged: (status) {
//                if (_selectedFriendIds.indexOf(friend.id) >= 0) {
//                  _selectedFriendIds.remove(friend.id);
//                }
//                else {
//                  _selectedFriendIds.add(friend.id);
//                }
//                setState(() {});
//              }
//          );
//        }
//        else {
//          return null;
//        }
//      },
//      itemCount: _editing ? _group.members.length + _friends.length + 1 : _group.members.length,
//    );
//  }
//}