import 'package:flutter/material.dart';

import 'package:smile_x/controller/api/theme_api.dart';

import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/invitation.dart';
import 'package:smile_x/model/theme.dart';
import 'package:smile_x/views/tab/tab.dart';
import 'views.dart';

class ThemeInvitedController extends StatefulWidget {
  final String code;

  ThemeInvitedController(this.code);

  @override
  State<StatefulWidget> createState() => ThemeInvitedControllerState();
}

class ThemeInvitedControllerState extends State<ThemeInvitedController> {
  Invitation _invitation;
  bool _fetching = true;

  @override
  void initState() {
    super.initState();

    ThemeAPI.shared.fetchInvitation(widget.code).then((result) {
      setState(() {
        _fetching = false;
      });
      if (result.item2) {
        setState(() {
          _invitation = result.item1;
        });
      } else {
        showErrorDialog(context, result.item3);
      }
    });
  }

  Widget _bodyForStatus() {
    if (widget.code == null) {
      return Center(
        child: Text(L10n.of(context).themeInvitedInvalidLink),
      );
    } else if (_fetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return themeListView(context, [],
          _invitation == null ? [] : [_invitation], ThemeType.invited, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).themeInvitedTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => TabBarController())),
          )
        ],
      ),
      body: _bodyForStatus(),
    );
  }
}
