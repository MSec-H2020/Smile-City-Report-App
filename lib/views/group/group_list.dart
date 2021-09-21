//import 'package:flutter/material.dart';
//
//import 'package:smile_x/controller/api/user_api.dart';
//import 'package:smile_x/model/group.dart';
//import 'package:smile_x/utils/utils.dart';
//import 'package:smile_x/views/profile/profile.dart';
//import 'group_create.dart';
//import 'group_edit.dart';
//
//import 'package:smile_x/controller/api/log_api.dart';
//
//
//class GroupController extends StatefulWidget
//{
//  @override
//  State<StatefulWidget> createState() => GroupControllerState();
//}
//
//class GroupControllerState extends State<GroupController>
//{
//  // Property
//  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
//
//  List<Group> _groups = [];
//  Status _status = Status.loading;
//
//  @override
//  void initState()
//  {
//    // Invoke super
//    super.initState();
//
//    LogAPI.shared.postLog('group');
//
//
//    fetchGroups();
//  }
//
//  Future fetchGroups() async
//  {
//    final groups = await UserAPI.shared.fetchGroups();
//    setState(() {
//      _groups = groups;
//      _status = groups.length == 0 ? Status.no_data : Status.fetched;
//    });
//  }
//
//
//  Future _leaveAction(int index) async
//  {
//    final group = _groups[index];
//    final result = await UserAPI.shared.leave(group.id);
//    if (!result.item1) {
//      print(result.item2);
//      return;
//    }
//
//    setState(() {
//      _groups.removeAt(index);
//    });
//
//    _key.currentState.showSnackBar(SnackBar(
//      content: Text('leaved group ' + group.name),));
//  }
//
//
//  Widget _bodyForStatus()
//  {
//    var widget;
//    switch (_status) {
//      case Status.loading:
//        widget = Center(
//          child: CircularProgressIndicator(),
//        );
//        break;
//      case Status.fetched:
//        widget = _listView();
//        break;
//      case Status.no_data:
//        widget = Center(
//          child: Text('no groups you joined'),
//        );
//        break;
//    }
//    return widget;
//  }
//
//  Widget _listView()
//  {
//    return RefreshIndicator(
//      onRefresh: fetchGroups,
//      child: ListView.builder(
//        itemCount: _groups.length,
//        itemBuilder: (context, index) {
//          final group = _groups[index];
//          return Dismissible(
//            key: Key(group.name),
//            onDismissed: (direction) => _leaveAction(index),
//            background: Container(
//                color: Colors.red,
//                alignment: Alignment(1.0, 0.0),
//                child: Container(
//                  margin: EdgeInsets.only(right: 10),
//                  child: Text(
//                    'leave ' + group.name,
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: Colors.white,
//                    ),
//                  ),
//                )),
//            child: ListTile(
//              title: Text(group.name),
//              subtitle: Text(group.memberCount()),
//              onTap: () async {
//                final result = await Navigator.of(context).push(
//                    MaterialPageRoute(builder: (context) => GroupEditController(group))
//                ) as GroupStatus ?? null;
//                if (result == GroupStatus.update) {
//                  await fetchGroups();
//                  _key.currentState.hideCurrentSnackBar();
//                  _key.currentState.showSnackBar(SnackBar(content: Text('update group ' + group.name),));
//                }
//              },
//              trailing: Icon(Icons.keyboard_arrow_right),
//            ),
//          );
//        },
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return Scaffold(
//      key: _key,
//      appBar: AppBar(
//        title: Text('Group'),
//          leading: IconButton(
//            icon: Icon(Icons.account_circle),
//            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => ProfileController()
//            )),
//          )
//      ),
//      body: _bodyForStatus(),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.create),
//        onPressed: () async {
//          final result = await Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) => GroupCreateController()
//            )
//          ) as GroupStatus ?? null;
//          if (result == GroupStatus.create) {
//            fetchGroups();
//            _key.currentState.hideCurrentSnackBar();
//            _key.currentState.showSnackBar(SnackBar(content: Text('create new group'),));
//          }
//        },
//      ),
//    );
//  }
//}