//import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//
//import 'package:smile_x/controller/api/user_api.dart';
//import 'package:smile_x/utils/utils.dart';
//import 'package:smile_x/model/user.dart';
//import 'package:smile_x/controller/api/group_api.dart';
//
//
//
//class GroupCreateController extends StatefulWidget
//{
//  @override
//  State<StatefulWidget> createState() => GroupCreateControllerState();
//}
//
//class GroupCreateControllerState extends State<GroupCreateController>
//{
//  List<User> _users = [];
//  String _name;
//  List<int> _selectedFriendIds = [];
//
//  @override
//  void initState()
//  {
//    // Invoke super
//    super.initState();
//
//    // Fetch users
//    UserAPI.shared.fetchUsers().then((users) {
//      setState(() {
//        _users = users;
//      });
//    });
//  }
//
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('new group'),
//        actions: <Widget>[
//          Builder(
//            builder: (context) {
//              return IconButton(
//                icon: Icon(Icons.share),
//                onPressed: () {
//                  // For no name
//                  if (_name == null) {
//                    Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text('fill the new group name'),
//                    ));
//                    return;
//                  }
//                  // For no member
//                  if (_selectedFriendIds.length == 0) {
//                    Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text('choose new group members'),
//                    ));
//                    return;
//                  }
//
//                  GroupAPI.shared.postGroup(_name, _selectedFriendIds).then((result) {
//                    if (!result.item1) {
//                      print('error');
//                      return;
//                    }
//                    Navigator.of(context).pop(GroupStatus.create);
//
//                  });
//                },
//              );
//            },
//          ),
//        ],
//      ),
//      body: Column(
//        children: <Widget>[
//          Container(
//            height: 60,
//            margin: EdgeInsets.all(20),
//            child: TextField(
//              decoration: InputDecoration(
//                border: InputBorder.none,
//                labelText: 'New Group Name'
//              ),
//              onChanged: (text) {
//                setState(() {
//                  _name = text;
//                });
//              },
//            ),
//          ),
//
//          Flexible(
//              child: ListView.builder(
//                itemCount: _users.length,
//                itemBuilder: (context, index) {
//                  var user = _users[index];
//                  return CheckboxListTile(
//                    value: _selectedFriendIds.indexOf(user.id) >= 0,
//                    title: Row(
//                      children: <Widget>[
//                        CircleAvatar(
//                          backgroundImage: user.iconUrl == null ? null : CachedNetworkImageProvider(user.iconUrl),
//                          //backgroundImage: CachedNetworkImageProvider(user.iconUrl),
//                        ),
//                        Container(
//                          margin: EdgeInsets.only(left: 10),
//                          child: Text(user.name),
//                        ),
//                      ],
//                    ),
//                    onChanged: (status) {
//                      if (_selectedFriendIds.indexOf(user.id) >= 0) {
//                        _selectedFriendIds.remove(user.id);
//                      }
//                      else {
//                        _selectedFriendIds.add(user.id);
//                      }
//                      setState(() {});
//                    },
//                  );
//                  },
//            )
//          )
//        ],
//      ),
//    );
//  }
//
//  Future upload(BuildContext context) async
//  {
//
//  }
//}