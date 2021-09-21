import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/controller/point_manager.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/views/icon/icon.dart';
import 'package:smile_x/views/login/login.dart';
import 'package:smile_x/views/tab/tab.dart';

import 'dart:async';
import 'dart:io';

class SignUpController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpControllerState();
}

enum Profile { gender, age, job, area }

class SignUpControllerState extends State<SignUpController> {
  // Property
  File _iconFile;
  String _iconAsset;
  String _nickname;
  String _password;
  List<String> _ages = <String>[
    '18~19',
    '20~29',
    '30~39',
    '40~49',
    '50~59',
    '60~69',
    '70~79',
    '80~89',
    '90~99',
    '100~109',
    '110~'
  ];
  List<String> _areas = <String>['Asia', 'US', 'Europa'];
  List<String> _answers = <String>[null, null, null, null];

  String _marketplaceUsername;
  String _marketplacePublicKey;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  bool _uploading = false;

  @override
  void initState() {
    _iconAsset = 'assets/user/${Random().nextInt(13)}.jpg';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(L10n.of(context).signupTitle),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;

                  setState(() {
                    _uploading = true;
                  });

                  final bytes = await imageBytes();
                  final result = await UserAPI.shared.postUser(
                    _nickname,
                    _password,
                    _answers[Profile.gender.index],
                    (Profile.age.index + 1) * 10,
                    _answers[Profile.area.index],
                    _answers[Profile.job.index],
                    bytes,
                  );

                  // For error
                  if (!result.item2) {
                    showErrorDialog(context, result.item3);
                  } else {
                    // Update prefs
                    await setPrefs(PrefsKey.UserId, result.item1.id.toString());
                    await setPrefs(PrefsKey.Nickname, _nickname);
                    await setPrefs(PrefsKey.Icon, base64Encode(bytes));

                    await setPrefs(
                        PrefsKey.MarketplaceUsername, _marketplaceUsername);
                    await setPrefs(
                        PrefsKey.MarketplacePublicKey, _marketplacePublicKey);

                    // Update point
                    PointManager.shared.showPointNotification(PointUsage.login);

                    // Push controller
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => TabBarController()));
                    //_formKey.currentState.save();
                  }

                  setState(() {
                    _uploading = false;
                  });
                })
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _uploading,
          child: Form(
            key: _formKey,
            child: Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: imageAction,
                            child: Container(
                              width: 64,
                              height: 64,
                              child: _buildIconView(),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: L10n.of(context).signupNickname,
                              ),
                              onChanged: (text) {
                                _nickname = text;
                              },
                              validator: (text) {
                                return text.length != 0
                                    ? null
                                    : L10n.of(context).signupRequired(
                                        L10n.of(context).signupNickname);
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: TextFormField(
                          controller: _controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).signupPassword,
                          ),
                          onChanged: (text) {
                            setState(() {
                              _password = text;
                            });
                          },
                          validator: (text) {
                            return text.length != 0
                                ? null
                                : L10n.of(context).signupRequired(
                                    L10n.of(context).signupPassword);
                          },
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).signupPasswordConfirm,
                          ),
                          onChanged: (text) {
                            setState(() {
                              _password = text;
                            });
                          },
                          validator: (text) {
                            if (text.length == 0)
                              return L10n.of(context).signupRequired(
                                  L10n.of(context).signupPasswordConfirm);
                            if (text != _controller.text)
                              return L10n.of(context).signupPasswordNotMatch;
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        child: dropdownForm(
                          L10n.of(context).signupGender,
                          Profile.gender.index,
                          _getGenderList(context),
                        ),
                      ),
                      Container(
                        child: dropdownForm(
                          L10n.of(context).signupAge,
                          Profile.age.index,
                          _ages,
                        ),
                      ),
                      Container(
                        child: dropdownForm(
                          L10n.of(context).signupJob,
                          Profile.job.index,
                          _getJobList(context),
                        ),
                      ),
                      Container(
                        child: dropdownForm(
                          L10n.of(context).signupArea,
                          Profile.area.index,
                          _areas,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      RaisedButton(
                        child: Text(L10n.of(context).signupLogin),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => LoginController(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

  Future<Uint8List> imageBytes() async {
    if (_iconAsset != null) {
      final data = await FlutterImageCompress.compressAssetImage(
        _iconAsset,
        quality: 40,
        minHeight: 540,
      );
      return Uint8List.fromList(data);
    }
    if (_iconFile != null) {
      final data = await FlutterImageCompress.compressWithFile(
        _iconFile.path,
        quality: 40,
        minHeight: 540,
      );
      return Uint8List.fromList(data);
    }
    return Uint8List(0);
  }

  Widget _buildIconView() {
    if (_iconAsset != null)
      return Image(
        image: AssetImage(_iconAsset),
        fit: BoxFit.cover,
      );
    if (_iconFile != null)
      return Image.file(
        _iconFile,
        fit: BoxFit.cover,
      );
    return null;
  }

  Widget dropdownForm(String label, int index, List<String> items) {
    return FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _answers[index],
                isDense: true,
                onChanged: (String value) {
                  setState(() {
                    _answers[index] = value;
                    state.didChange(value);
                  });
                },
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ));
      },
    );
  }

  Future imageAction() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IconController(IconType.user),
      ),
    );
    if (result == null) {
      return;
    }

    if (result.runtimeType == String) {
      setState(() {
        _iconAsset = result as String;
        _iconFile = null;
      });
    } else {
      setState(() {
        _iconAsset = null;
        _iconFile = result as File;
      });
    }
  }

  List<String> _getGenderList(BuildContext context) {
    return [
      L10n.of(context).signupGenderMale,
      L10n.of(context).signupGenderFemale,
      L10n.of(context).signupGenderOther,
    ];
  }

  List<String> _getJobList(BuildContext context) {
    return [
      L10n.of(context).signupJobBusinessProfessional,
      L10n.of(context).signupJobBusinessOwner,
      L10n.of(context).signupJobSelfEmployed,
      L10n.of(context).signupJobGovernment,
      L10n.of(context).signupJobOtherSectors,
      L10n.of(context).signupJobStudent,
      L10n.of(context).signupJobHomemaker,
      L10n.of(context).signupJobOthers,
    ];
  }
}
