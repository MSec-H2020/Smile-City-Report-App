// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:smile_x/views/theme/invited.dart';
import 'package:flutter/material.dart';
import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/invitation.dart';
import 'package:smile_x/model/theme.dart';
import 'views.dart';
import 'users.dart';

class ThemeController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ThemeControllerState();
}

enum Status { loading, fetched }

class ThemeControllerState extends State<ThemeController> {
  // Property
  List<ReportTheme> _themes = [];
  List<Invitation> _invitations = [];

  Status _status = Status.loading;

  @override
  void initState() {
    loadData();

    super.initState();
  }

  Future loadData() async {
    await loadTheme();
    await loadInvitations();
    setState(() {
      _status = Status.fetched;
    });
  }

  Future loadTheme() async {
    final result = await UserAPI.shared.fetchThemes();
    if (result.item2) {
      setState(() {
        _themes = result.item1;
      });
    } else {
      showErrorDialog(context, result.item3);
    }
  }

  Future loadInvitations() async {
    final result = await UserAPI.shared.fetchInvitations();
    if (result.item2) {
      setState(() {
        _invitations = result.item1;
      });
    } else {
      showErrorDialog(context, result.item3);
    }
  }

  Widget _bodyForStatus() {
    var widget;
    switch (_status) {
      case Status.loading:
        widget = Center(
          child: CircularProgressIndicator(),
        );
        break;
      case Status.fetched:
        widget = TabBarView(
          children: <Widget>[
            _themes.length == 0
                ? Center(
                    child: Text(L10n.of(context).themeNoJoiningTheme),
                  )
                : themeListView(
                    context, _themes, _invitations, ThemeType.joining, false,
                    loadThemes: loadTheme, loadInvitations: loadInvitations),
            _invitations.length == 0
                ? Center(
                    child: Text(L10n.of(context).themeNoInvitedTheme),
                  )
                : themeListView(
                    context, _themes, _invitations, ThemeType.invited, false,
                    loadThemes: loadTheme, loadInvitations: loadInvitations)
          ],
        );
        break;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      Tab(
        text: L10n.of(context).themeTabJoining,
      ),
      Tab(
        text: L10n.of(context).themeTabInvited,
      )
    ];

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).themeTitle),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(MdiIcons.qrcodeScan),
          //     onPressed: () async {
          //       // Read QR code
          //       final result = await BarcodeScanner.scan();
          //       final uri = Uri.parse(result) ?? null;
          //       final inviteCode = uri.queryParameters['code'];
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (_) => ThemeInvitedController(inviteCode)));
          //     },
          //   )
          // ],
          bottom: TabBar(
            tabs: _tabs,
          ),
        ),
        body: _bodyForStatus(),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.create),
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                      builder: (_) =>
                          ThemeUsersController(ThemeUsers.create, [])));
              if (result == null) loadTheme();
            },
          ),
        ),
      ),
    );
  }
}
