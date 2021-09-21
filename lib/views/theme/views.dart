import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:smile_x/controller/api/theme_api.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/invitation.dart';
import 'package:smile_x/utils/formatter.dart';
import 'package:smile_x/views/post/camera.dart';
import 'package:smile_x/views/tab/tab.dart';
import 'package:smile_x/model/theme.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/views/theme/invite.dart';
import 'package:smile_x/views/theme/users.dart';
import 'detail.dart';
import 'member.dart';

Widget themeListView(
  BuildContext context,
  List<ReportTheme> themes,
  List<Invitation> invitations,
  ThemeType type,
  bool fromInvitedController, {
  Function loadThemes,
  Function loadInvitations,
}) {
  final width = MediaQuery.of(context).size.width;
  return ListView.builder(
    itemCount: type == ThemeType.joining ? themes.length : invitations.length,
    itemBuilder: (context, index) {
      ReportTheme theme;
      Invitation invitation;
      if (type == ThemeType.joining) theme = themes[index];
      if (type == ThemeType.invited) {
        invitation = invitations[index];
        theme = invitation.theme;
      }
      return Card(
        elevation: 5.0,
        margin: EdgeInsets.only(right: 20, left: 20, top: 10),
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ThemeDetailController(theme, type))),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: contentView(theme),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 20),
                      width: width / 3,
                      height: width / 3,
                      color: Colors.grey[300],
                      child: theme.image == null
                          ? null
                          : CachedNetworkImage(
                              imageUrl: theme.image,
                              fit: BoxFit.cover,
                            ),
                    )
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ThemeMemberController(
                          theme, type == ThemeType.joining))),
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 32,
                    child: Center(
                      child: FutureBuilder<List<User>>(
                        future: theme.joining,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final List<User> joining = snapshot.hasData
                              ? _truncateMembers(snapshot.data, 4)
                              : [];
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: joining.length + 1,
                            itemBuilder: (context, index) {
                              if (index == joining.length) {
                                return Container(
                                  height: 32,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        joining.length.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(Icons.navigate_next,
                                          color: Colors.white),
                                      SizedBox(
                                        width: 0,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              final member = joining[index];
                              return Container(
                                margin: EdgeInsets.only(left: 6),
                                width: 32,
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    member.iconUrl,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: type == ThemeType.joining
                        ? _buildJoinedSection(
                            context,
                            theme,
                            loadThemes,
                          )
                        : [
                            Expanded(
                              child: _buildJoinButton(
                                context,
                                theme,
                                loadThemes,
                                fromInvitedController,
                                loadInvitations,
                              ),
                            ),
                          ],
                  ),
                ),
                type != ThemeType.invited
                    ? SizedBox()
                    : Divider(
                        thickness: 1,
                      ),
                type != ThemeType.invited
                    ? SizedBox()
                    : ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          child: invitation == null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    invitation.inviter.iconUrl,
                                  ),
                                ),
                        ),
                        title: Text(
                          invitation == null
                              ? '?'
                              : L10n.of(context).themeListViewInvited(
                                  invitation.inviter.nickname),
                        ),
                      ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

List<Widget> _buildJoinedSection(
  BuildContext context,
  ReportTheme theme,
  Function loadThemes,
) {
  return [
    Expanded(
      child: _buildPostButton(context, theme),
    ),
    FutureBuilder<bool>(
      future: _canInvite(theme),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return SizedBox(width: 16);
        }
        return Container();
      },
    ),
    FutureBuilder<bool>(
      future: _canInvite(theme),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Expanded(
            child: _buildInviteButton(context, theme, loadThemes),
          );
        }
        return Container();
      },
    ),
  ];
}

Future<bool> _canInvite(ReportTheme theme) async {
  final userIdStr = await getPrefs(PrefsKey.UserId);
  final userId = int.parse(userIdStr) ?? 0;
  return theme.isPublic || userId == theme.ownerId;
}

Widget _buildPostButton(
  BuildContext context,
  ReportTheme theme,
) {
  return RaisedButton(
    color: Colors.blue,
    shape: StadiumBorder(),
    child: Text(
      L10n.of(context).themeListViewPost,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoController(theme),
        fullscreenDialog: true,
      ),
    ),
  );
}

Widget _buildInviteButton(
  BuildContext context,
  ReportTheme theme,
  Function loadThemes,
) {
  return RaisedButton(
    color: Colors.blue,
    shape: StadiumBorder(),
    child: Text(
      L10n.of(context).themeListViewInvite,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    onPressed: () => inviteAction(context, theme, loadThemes),
  );
}

Widget _buildJoinButton(
  BuildContext context,
  ReportTheme theme,
  Function loadThemes,
  bool fromInvitedController,
  Function loadInvitations,
) {
  return RaisedButton(
    color: Colors.blue,
    shape: StadiumBorder(),
    child: Text(
      L10n.of(context).themeListViewJoin,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    onPressed: () => joinAction(
      context,
      theme,
      loadThemes,
      loadInvitations,
      fromInvitedController,
    ),
  );
}

Widget contentView(ReportTheme theme) {
  return Container(
    margin: EdgeInsets.only(left: 20, top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          theme.title == null ? '---' : theme.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          theme.message,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          theme.timestamp == null
              ? '---'
              : Formatter().formatCreatedAt(theme.timestamp),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder<User>(
          future: theme.owner,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Container();
            }
            return Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      snapshot.data.iconUrl,
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  snapshot.data.nickname,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

Future joinAction(BuildContext context, ReportTheme theme, Function loadThemes,
    Function loadInvitations, bool invited) async {
  final result = await ThemeAPI.shared.join(theme.id);
  if (!result.item1) {
    showErrorDialog(context, result.item2);
  } else {
    if (invited) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => TabBarController()));
    } else {
      if (loadThemes != null) loadThemes();
      if (loadInvitations != null) loadInvitations();
    }
  }
}

Future<String> fetchInviteCode(
  BuildContext context,
  ReportTheme theme,
) async {
  final result = await ThemeAPI.shared.invite(theme.id, true);
  return result.item1;
}

Future<void> inviteAction(
  BuildContext context,
  ReportTheme theme,
  Function loadTheme,
) async {
  final joining = await theme.joining;
  final invited = await theme.invited;

  final userIds = (joining + invited).map((user) => user.id).toList();
  showDialog(
    context: context,
    builder: (_) {
      return SimpleDialog(
        title: Text(L10n.of(context).themeListViewInviteDialog),
        children: <Widget>[
          SimpleDialogOption(
            child: Text(L10n.of(context).themeListViewInviteDialogChooseUsers),
            onPressed: () async {
              final result = await Navigator.of(context)
                  .push<List<User>>(MaterialPageRoute(
                      builder: (_) => ThemeUsersController(
                            ThemeUsers.invite,
                            userIds,
                            theme: theme,
                          )));
              if (result == null) return;
              loadTheme();
              Navigator.pop(context);
            },
          ),
          Divider(
            thickness: 1,
          ),
          SimpleDialogOption(
              child: Text(L10n.of(context).themeListViewInviteDialogAllUsers),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ThemeInviteController(theme)));
              }),
        ],
      );
    },
  );
}

List<User> _truncateMembers(List<User> members, int max) {
  if (members.length <= max) {
    return members;
  } else {
    return members.sublist(0, max);
  }
}
