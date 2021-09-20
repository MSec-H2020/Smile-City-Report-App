import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/controller/point_manager.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/views/login/signup.dart';
import 'package:smile_x/views/tab/tab.dart';

import 'package:network_image_to_byte/network_image_to_byte.dart';

class LoginController extends StatefulWidget {
  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  String _nickname;
  String _password;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).loginTitle),
        ),
        body: ModalProgressHUD(
            inAsyncCall: _loading,
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      hintText: L10n.of(context).loginNickname,
                    ),
                    onChanged: (text) {
                      _nickname = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: L10n.of(context).loginPassword,
                    ),
                    obscureText: true,
                    onChanged: (text) {
                      _password = text;
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text(L10n.of(context).loginTitle),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      final result =
                          await UserAPI.shared.login(_nickname, _password);
                      if (!result.item1) {
                        // Failed to login.
                        String message = result.item3 != null
                            ? result.item3
                            : L10n.of(context).loginErrorMessage;
                        showErrorDialog(context, message);
                      } else {
                        FocusScope.of(context).unfocus();

                        final user = result.item2;

                        await setPrefs(PrefsKey.UserId, user.id.toString());
                        await setPrefs(PrefsKey.Nickname, user.nickname);

                        try {
                          final byteImage =
                              await networkImageToByte(user.iconUrl);
                          await setPrefs(
                              PrefsKey.Icon, base64Encode(byteImage));
                        } catch (_) {}

                        // PointManager.shared
                        //     .showPointNotification(context, PointUsage.login);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => TabBarController()));
                      }
                      setState(() {
                        _loading = false;
                      });
                    },
                  ),
                  SizedBox(height: 50),
                  RaisedButton(
		        child: Text(L10n.of(context).loginSignup),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => SignUpController(),
                            ),
                          );
                        },
                      )
                ],
              ),
            )));
  }

  showErrorDialog(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
