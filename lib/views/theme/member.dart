import 'package:flutter/material.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/theme.dart';

import 'package:smile_x/model/user.dart';
import 'users.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ThemeMemberController extends StatefulWidget {
  final ReportTheme theme;
  final bool editable;

  ThemeMemberController(this.theme, this.editable);

  @override
  State<StatefulWidget> createState() => ThemeMemberControllerState();
}

class ThemeMemberControllerState extends State<ThemeMemberController> {
  @override
  void initState() {
    // Invoke super
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).themeMemberTitle),
      ),
      body: FutureBuilder<List<List<User>>>(
          future: Future.wait([widget.theme.joining, widget.theme.invited]),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Container();
            }
            final joining = snapshot.data[0];
            final invited = snapshot.data[1];
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: joining.length + invited.length + 4,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            L10n.of(context).themeMemberOwner,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      } else if (index == 1) {
                        return FutureBuilder<User>(
                          future: widget.theme.owner,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasData) {
                              return ListTile(
                                title: Text(snapshot.data.nickname),
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      snapshot.data.iconUrl),
                                ),
                              );
                            } else {
                              return ListTile(title: Text('---'));
                            }
                          },
                        );
                      } else if (index == 2) {
                        return Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            L10n.of(context).themeMemberJoining +
                                ' ' +
                                joining.length.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      } else if (index <= joining.length + 2) {
                        final member = joining[index - 3];
                        return ListTile(
                          title: Text(member.nickname),
                          leading: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(member.iconUrl),
                          ),
                        );
                      } else if (index == joining.length + 3) {
                        return Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            L10n.of(context).themeMemberInvited +
                                ' ' +
                                invited.length.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        final user = invited[index - joining.length - 4];
                        return ListTile(
                          title: Text(user.nickname),
                          leading: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.iconUrl),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              widget.editable
                                  ? L10n.of(context).themeMemberInvite
                                  : L10n.of(context)
                                      .themeMemberJoin(widget.theme.title),
                            ),
                            onPressed: widget.editable
                                ? () {
                                    inviteAction(joining, invited);
                                  }
                                : () {},
                          ),
                        ),
                      ])),
                )
              ],
            );
          }),
    );
  }

  Future inviteAction(List<User> joining, List<User> invited) async {
    final ids =
        joining.map((u) => u.id).toList() + invited.map((u) => u.id).toList();
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ThemeUsersController(
              ThemeUsers.invite,
              ids,
              theme: widget.theme,
            )));
    if (result == null) return;
    final users = cast<List<User>>(result);
    if (users == null) return;

    // Update
    setState(() {
      invited.addAll(users);
    });
  }
}
