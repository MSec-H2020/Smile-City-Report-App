import 'package:flutter/material.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/controller/api/theme_api.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../icon/icon.dart';

class ThemeCreateController extends StatefulWidget {
  final List<User> members;

  ThemeCreateController(this.members);

  @override
  State<StatefulWidget> createState() => ThemeCreateControllerState();
}

class ThemeCreateControllerState extends State<ThemeCreateController> {
  List<User> _members = [];

  bool _uploading = false;

  String _title;
  File _iconFile;
  String _iconAsset;
  String _message;
  bool _isFacing = true;
  bool _isPublic = true;
  bool _isGanonymize = false;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _members = widget.members;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).themeCreateTitle),
        actions: <Widget>[
          FlatButton(
            child: Text(
              L10n.of(context).themeCreateCreate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();

              if (!_key.currentState.validate()) return;
              setState(() {
                _uploading = true;
              });
              final bytes = await imageBytes();
              final result = await ThemeAPI.shared.postTheme(
                _title,
                _members.map((m) => m.id).toList(),
                _message,
                _isPublic,
                _isFacing,
                _isGanonymize,
                bytes,
              );
              if (result.item1) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                setState(() {
                  _uploading = false;
                });
                showErrorDialog(context, result.item2);
              }
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _uploading,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 20),
                      child: Column(
                        children: <Widget>[
                          _buildTitleSection(),
                          _buildDescriptionSection(),
                          _buildIconSection(),
                          _buildFacingForm(),
                          _buildGanonymizeForm(),
                          _buildInviteForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  color: Colors.blue[300],
                  height: 100,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 5),
                    child: ListView.builder(
                      itemCount: _members.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final user = _members[index];
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
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          user.iconUrl,
                                        ),
                                      ),
                                      Text(
                                        user.nickname,
                                        style: TextStyle(color: Colors.white),
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
                                      _members.remove(user);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: L10n.of(context).themeCreateName,
          hintText: L10n.of(context).themeCreateNameHint,
        ),
        onChanged: (text) {
          setState(() {
            _title = text;
          });
        },
        validator: (text) {
          return text.length != 0
              ? null
              : L10n.of(context)
                  .themeCreateRequired(L10n.of(context).themeCreateName);
        },
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: L10n.of(context).themeCreateDescription,
        ),
        maxLines: 2,
        onChanged: (text) {
          setState(() {
            _message = text;
          });
        },
        validator: (text) {
          return text.length != 0
              ? null
              : L10n.of(context)
                  .themeCreateRequired(L10n.of(context).themeCreateDescription);
        },
      ),
    );
  }

  Widget _buildIconSection() {
    return Container(
      child: FormField(
        validator: (value) {
          return value == null
              ? L10n.of(context)
                  .themeCreateRequired(L10n.of(context).themeCreateIcon)
              : null;
        },
        builder: (FormFieldState state) {
          return InputDecorator(
              decoration: InputDecoration(
                labelText: L10n.of(context).themeCreateIcon,
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                errorText: state.hasError ? state.errorText : null,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 128,
                    height: 128,
                    color: Colors.grey[300],
                    child: GestureDetector(
                      onTap: () => updateIcon(state),
                      child: iconView(),
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

  Widget _buildFacingForm() {
    return FormField(
      initialValue: _isFacing,
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: L10n.of(context).themeCreateSmilePhoto,
            labelStyle: TextStyle(color: Colors.grey),
            errorText: state.hasError ? state.errorText : null,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(L10n.of(context).themeCreateSmilePhotoFacing),
                  Radio(
                    value: true,
                    groupValue: _isFacing,
                    onChanged: (value) {
                      setState(() {
                        _isFacing = value;
                        state.didChange(value);
                      });
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(L10n.of(context).themeCreateSmilePhotoMasking),
                  Radio(
                    value: false,
                    groupValue: _isFacing,
                    onChanged: (value) {
                      setState(() {
                        _isFacing = value;
                        state.didChange(value);
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGanonymizeForm() {
    return FormField(
      initialValue: _isGanonymize,
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: L10n.of(context).themeCreateBackPhoto,
            labelStyle: TextStyle(color: Colors.grey),
            errorText: state.hasError ? state.errorText : null,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(L10n.of(context).themeCreateBackPhotoNoEdit),
                  Radio(
                    value: false,
                    groupValue: _isGanonymize,
                    onChanged: (value) {
                      setState(() {
                        _isGanonymize = value;
                        state.didChange(value);
                      });
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(L10n.of(context).themeCreateBackPhotoGanonymize),
                  Radio(
                    value: true,
                    groupValue: _isGanonymize,
                    onChanged: (value) {
                      setState(() {
                        _isGanonymize = value;
                        state.didChange(value);
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInviteForm() {
    return FormField(
      initialValue: _isPublic,
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: L10n.of(context).themeCreateInvite,
            labelStyle: TextStyle(color: Colors.grey),
            errorText: state.hasError ? state.errorText : null,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(L10n.of(context).themeCreateInvitePublic),
                  Radio(
                    value: true,
                    groupValue: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value;
                        state.didChange(value);
                      });
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(L10n.of(context).themeCreateInvitePrivate),
                  Radio(
                    value: false,
                    groupValue: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value;
                        state.didChange(value);
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Uint8List> imageBytes() async {
    if (_iconFile != null) {
      final data = await FlutterImageCompress.compressWithFile(
        _iconFile.path,
        quality: 40,
        minHeight: 540,
      );
      return Uint8List.fromList(data);
    } else {
      final data = await FlutterImageCompress.compressAssetImage(
        _iconAsset,
        quality: 40,
        minHeight: 540,
      );
      return Uint8List.fromList(data);
    }
  }

  Widget iconView() {
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

  Future updateIcon(FormFieldState state) async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => IconController(IconType.theme)));
    if (result == null) return;

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
    state.didChange(result);
  }
}
