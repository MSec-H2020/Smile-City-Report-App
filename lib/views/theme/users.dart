import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smile_x/controller/api/theme_api.dart';

import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/theme.dart';

import 'package:smile_x/model/user.dart';
import 'create.dart';

enum ThemeUsers { create, invite }

class ThemeUsersController extends StatefulWidget {
  final ThemeUsers type;
  final List<int> joiningUserIds;
  final ReportTheme theme;

  ThemeUsersController(this.type, this.joiningUserIds, {this.theme});

  @override
  State<StatefulWidget> createState() => ThemeUsersControllerState();
}

class ThemeUsersControllerState extends State<ThemeUsersController> {
  // Property
  List<User> _users = [];
  List<User> _selectedUsers = [];

  bool _loading = true;

  @override
  void initState() {
    _getUsers();

    super.initState();
  }

  Future<void> _getUsers() async {
    setState(() {
      _loading = true;
    });

    final result = await UserAPI.shared.fetchUsers(true);

    if (!result.item2) {
      setState(() {
        _loading = false;
      });
      if (result.item3 == 'no data') {
        return;
      }
      showErrorDialog(context, result.item3);
    } else {
      setState(() {
        _loading = false;
        _selectedUsers.clear();
        _users = result.item1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = _users
        .where((user) => !widget.joiningUserIds.contains(user.id))
        .toList();
    return Scaffold(
      appBar: _appBar(),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: users.isEmpty
            ? Center(child: Text(L10n.of(context).themeUsersNoData))
            : Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return _buildUserTile(user);
                        },
                      ),
                    ),
                    _selectedUsers.isNotEmpty
                        ? _buildSelectedUsersContainer()
                        : Container(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildUserTile(User user) {
    return ListTile(
      onTap: () {
        setState(() {
          if (_selectedUsers.contains(user)) {
            _selectedUsers.remove(user);
          } else {
            _selectedUsers.add(user);
          }
        });
      },
      leading: Checkbox(
        value: _selectedUsers.contains(user),
        onChanged: (value) {
          setState(() {
            if (_selectedUsers.contains(user)) {
              _selectedUsers.remove(user);
            } else {
              _selectedUsers.add(user);
            }
          });
        },
      ),
      title: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.iconUrl),
          ),
          SizedBox(
            width: 10,
          ),
          Text(user.nickname)
        ],
      ),
    );
  }

  Widget _buildSelectedUsersContainer() {
    return Container(
      color: Colors.blue[300],
      height: 100,
      child: Container(
        margin: EdgeInsets.only(top: 5, left: 5),
        child: ListView.builder(
          itemCount: _selectedUsers.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final user = _users
                .where((user) => user == _selectedUsers[index])
                .toList()
                .first;
            return Container(
              margin: EdgeInsets.only(right: 5, left: 5),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              user.iconUrl,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 60,
                              child: Text(
                                user.nickname,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 6,
                      )
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      child: Icon(
                        Icons.cancel,
                        size: 20,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedUsers.remove(user);
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future memberAction() async {
    switch (widget.type) {
      case ThemeUsers.create:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ThemeCreateController(_selectedUsers)));
        break;
      case ThemeUsers.invite:
        final result = await ThemeAPI.shared.invite(widget.theme.id, false,
            invited: _selectedUsers.map((u) => u.id).toList());
        if (!result.item2) {
          showErrorDialog(context, result.item3);
        } else {
          print('success');
          Navigator.of(context).pop(_selectedUsers);
        }
        break;
    }
  }

  Widget _appBar() {
    return AppBar(
      title: Text(
        L10n.of(context).themeUsersTitle,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            widget.type == ThemeUsers.invite
                ? L10n.of(context).themeUsersInvite
                : L10n.of(context).themeUsersNext,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _selectedUsers.length == 0 ? null : memberAction,
          textColor: Colors.white,
          disabledTextColor: Colors.white38,
        )
      ],
    );
  }
}
