import 'dart:convert';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/main.dart';
import 'package:smile_x/model/point.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';
import 'api/point_api.dart';

enum PointUsage {
  login,
  post,
  post_smile,
  ganonymize,
  post_comment,
  react_smile,
}

class PointManager {
  // -------------------------------------//
  //  -- Initialize --
  //--------------------------------------//

  static final shared = PointManager._internal();
  List<Point> _points = [];
  bool _checkingPointsAchived = false;

  factory PointManager() {
    return shared;
  }

  PointManager._internal();

  Future fetchPointUsages() async {
    // Fetch point ..
    final result = await PointAPI.shared.fetchPoints();

    if (!result.item2) print('failed loading point usage');

    this._points = result.item1;
    print('loaded point usage');
  }

  Point _pointFor(PointUsage usage) {
    print(this._points);

    switch (usage) {
      case PointUsage.login:
        return _points.where((p) => p.reason == 'login').toList()[0];
      case PointUsage.post:
        return _points.where((p) => p.reason == 'post').toList()[0];
      case PointUsage.post_smile:
        return _points.where((p) => p.reason == 'post_smile').toList()[0];
      case PointUsage.ganonymize:
        return _points.where((p) => p.reason == 'ganonymize').toList()[0];
      case PointUsage.post_comment:
        return _points.where((p) => p.reason == 'post_comment').toList()[0];
      case PointUsage.react_smile:
        return _points.where((p) => p.reason == 'react_smile').toList()[0];
      default:
        return null;
    }
  }

  String _getReason(BuildContext context, PointUsage usage) {
    switch (usage) {
      case PointUsage.login:
        return L10n.of(context).pointManagerReasonLogin;
      case PointUsage.post:
        return L10n.of(context).pointManagerReasonPost;
      case PointUsage.post_smile:
        return L10n.of(context).pointManagerReasonPostSmile;
      case PointUsage.ganonymize:
        return L10n.of(context).pointManagerReasonGanonymize;
      case PointUsage.post_comment:
        return L10n.of(context).pointManagerReasonPostComment;
      case PointUsage.react_smile:
        return L10n.of(context).pointManagerReasonReactSmile;
      default:
        return '';
    }
  }

  Icon _getIcon(PointUsage usage) {
    final iconSize = 40.0;
    switch (usage) {
      case PointUsage.login:
        return Icon(Icons.star, color: Colors.yellow, size: iconSize);
      case PointUsage.post:
        return Icon(Icons.send, color: Colors.yellow, size: iconSize);
      case PointUsage.post_smile:
        return Icon(Icons.favorite, color: Colors.pink, size: iconSize);
      case PointUsage.ganonymize:
        return Icon(Icons.landscape, color: Colors.green, size: iconSize);
      case PointUsage.post_comment:
        return Icon(Icons.chat, color: Colors.orange, size: iconSize);
      case PointUsage.post_comment:
        return Icon(Icons.face_retouching_natural,
            color: Colors.orange, size: iconSize);
      default:
        return Icon(Icons.star, color: Colors.amber, size: iconSize);
    }
  }

  void showPointNotification(PointUsage usage) {
    final point = _pointFor(usage);
    final BuildContext context = navigatorKey.currentContext;

    UserAPI.shared.postPoint(point.id).then(
      (result) {
        if (!result.item1) print('failed udpate point');
        showOverlayNotification(
          (context) {
            return Card(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: ListTile(
                leading: _getIcon(usage),
                title: Text(
                  _getReason(context, usage),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(L10n.of(context)
                    .pointManagerNotificationDescription(
                        point.point.toString())),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => OverlaySupportEntry.of(context).dismiss()),
              ),
            );
          },
          duration: Duration(milliseconds: 4000),
        );

        checkIfPointsAchived();
      },
    );
  }

  void checkIfPointsAchived() {
    if (_checkingPointsAchived) return;

    final BuildContext context = navigatorKey.currentContext;

    _checkingPointsAchived = true;
    UserAPI.shared.fetchPointSummary().then((result) async {
      _checkingPointsAchived = false;
      if (!result.item2) return;
      if (result.item1.allPoints >= 3000) {
        final hasOpened = await getHasOpendPointAchivedURL();
        if (hasOpened) return;

        String username = await getPrefs(PrefsKey.Nickname);
        String param1 = Uri.encodeComponent(username);
        String param2 = Uri.encodeComponent(
            sha256.convert(utf8.encode("smile" + username)).toString());

        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(L10n.of(context).pointManagerAchiveDialogTitle),
                content: Text(L10n.of(context).pointManagerAchiveDialogMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(L10n.of(context).couponUseDialogCancel),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final _url = L10n.of(context)
                          .pointManagerAchiveDialogURL(param1, param2);
                      await canLaunch(_url)
                          ? await launch(_url)
                          : throw 'Could not launch $_url';
                      setHasOpendPointAchivedURL(true);
                    },
                    child:
                        Text(L10n.of(context).pointManagerAchiveDialogAction),
                  ),
                ],
              );
            });
      }
    });
  }
}
