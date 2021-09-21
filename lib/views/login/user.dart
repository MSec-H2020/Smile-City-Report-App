//import 'package:flutter/material.dart';
//import 'package:smile_x/controller/api/user_api.dart';
//import 'package:smile_x/controller/preferences_manager.dart';
//import 'package:smile_x/views/tab/tab.dart';
//
//class UserLoginController extends StatefulWidget
//{
//  @override
//  State<StatefulWidget> createState() => UserLoginControllerState();
//}
//
//class UserLoginControllerState extends State<UserLoginController>
//{
//  // Property
//  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//  int userId;
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return Scaffold(
//      key: _key,
//      appBar: AppBar(
//        title: Text('Fill your user id'),
//      ),
//      body: Form(
//        key: _formKey,
//        child: Column(
//        children: <Widget>[
//          Container(
//            margin: EdgeInsets.only(right: 10, left: 10, top: 10),
//            child: TextFormField(
//              onChanged: (text) {
//                var value = int.tryParse(text);
//                if (value == null) return;
//                setState(() {
//                  userId = value;
//                });
//              },
//              validator: (text) {
//                var value = int.tryParse(text);
//                return value != null ? null : 'user id must be integer';
//              },
//            ),
//          )
//          ,
//          RaisedButton(
//            child: Text('login'),
//            onPressed: () async {
//              if (_formKey.currentState.validate()) {
//                _key.currentState.showSnackBar(SnackBar(content: Text('now loading'),));
//                final users = await UserAPI.shared.fetchUsers(userId: userId);
//
//                if (users.length == 0 || users.length > 1) {
//                  _key.currentState.hideCurrentSnackBar();
//                  _key.currentState.showSnackBar(SnackBar(content: Text('invalid id'),));
//                  return;
//                }
//
//                setPrefs(PrefsKey.FacebookId, users.first.facebookId);
//                setPrefs(PrefsKey.Nickname, users.first.name);
//                setPrefs(PrefsKey.FacebookEmail, users.first.email);
//                setPrefs(PrefsKey.UserId, users.first.id.toString());
//
//                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TabBarController()));
//              }
//
//
//            },
//          )
//        ],
//      ),
//    ));
//  }
//}