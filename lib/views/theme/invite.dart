import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:smile_x/l10n/l10n.dart';

import 'package:smile_x/model/theme.dart';

import 'package:smile_x/controller/api/theme_api.dart';

import 'dart:ui';

class ThemeInviteController extends StatefulWidget {
  final ReportTheme theme;

  ThemeInviteController(this.theme);

  @override
  State<StatefulWidget> createState() => ThemeInviteControllerState();
}

class ThemeInviteControllerState extends State<ThemeInviteController> {
  GlobalKey key = new GlobalKey();

  String _url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).themeInviteTitle),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  _url == null ? SizedBox() : SelectableText(_url),
                  RaisedButton(
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    child: Text(
                      _url == null
                          ? L10n.of(context).themeInviteCreateURL
                          : L10n.of(context).themeInviteShareURL,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_url == null) {
                        await fetchInviteCode(widget.theme);
                      } else {
                        Share.text(
                          L10n.of(context).themeInviteURL,
                          _url,
                          'text/plain',
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  _url == null
                      ? SizedBox()
                      : Center(
                          child: Container(
                            height: 300,
                            width: 300,
                            child: RepaintBoundary(
                              key: key,
                              child: QrImage(
                                data: _url,
                                size: 300,
                              ),
                            ),
                          ),
                        ),
                  RaisedButton(
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    child: Text(
                      _url == null
                          ? L10n.of(context).themeInviteCreateQR
                          : L10n.of(context).themeInviteShareQR,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_url == null) {
                        await fetchInviteCode(widget.theme);
                      } else {
                        RenderRepaintBoundary boundary =
                            key.currentContext.findRenderObject();
                        final image = await boundary.toImage(pixelRatio: 6.0);
                        final data =
                            await image.toByteData(format: ImageByteFormat.png);
                        await Share.file(
                          L10n.of(context).themeInviteQR,
                          'qr.png',
                          data.buffer.asUint8List(),
                          'image/png',
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future fetchInviteCode(ReportTheme theme) async {
    final result = await ThemeAPI.shared.invite(theme.id, true);
    if (!result.item2) return;
    final code = result.item1;
    setState(() {
      // TODO: URLの確認
      _url =
          'http://minami.jn.sfc.keio.ac.jp:3000/redirect/index?url=sushirepo://inivtes?code=$code';
    });
  }
}
