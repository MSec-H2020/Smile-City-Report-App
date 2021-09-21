import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smile_x/controller/api/ganonymizer_api.dart';
import 'package:smile_x/controller/api/smile_api.dart';
import 'package:smile_x/controller/api/sox_api.dart';
import 'package:smile_x/controller/point_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/theme.dart';
import 'package:image/image.dart' as ImageUtil;

import '../../controller/api/sox_api.dart';

class PostController extends StatefulWidget {
  final ReportTheme theme;
  final String frontPath;
  final String backPath;
  final double smilingProbability;

  PostController({
    @required this.theme,
    @required this.frontPath,
    @required this.backPath,
    @required this.smilingProbability,
  });

  @override
  _PostControllerState createState() => _PostControllerState();
}

class _PostControllerState extends State<PostController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _caption;

  bool _isGanonymize;
  bool _uploadSmilePhoto = true;
  bool _ganonymizing = false;
  bool _uploading = false;

  Uint8List _ganonymizedBytes;

  @override
  void initState() {
    _isGanonymize = widget.theme.isGanonymize;
    if (_isGanonymize) {
      _ganonymize();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(L10n.of(context).postTitle),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: _showDiscardDialog,
            ),
          ),
          body: Stack(
            children: [
              ModalProgressHUD(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            widget.theme.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(thickness: 1),
                        _buildCaptionForm(),
                        Divider(thickness: 1),
                        _buildFrontPhotoSection(),
                        Divider(thickness: 1),
                        _buildBackPhotoSection(),
                        Container(height: 100),
                      ],
                    ),
                  ),
                ),
                inAsyncCall: _uploading || _ganonymizing,
              ),
              Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Text(
                        L10n.of(context).postGanonymizing,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                visible: _ganonymizing,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.send),
            onPressed: _upload,
          ),
        ),
        onWillPop: () async => false);
  }

  Widget _buildCaptionForm() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Text(
            L10n.of(context).postCaption,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Center(
            child: TextFormField(
              initialValue: _caption,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: L10n.of(context).postCaption,
                  border: InputBorder.none),
              onChanged: (text) {
                setState(() {
                  _caption = text;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: Text(
            L10n.of(context).postBackPhoto,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16),
          child: Container(
            width: 200,
            height: 200,
            child: _isGanonymize && _ganonymizedBytes != null
                ? Image.memory(
                    _ganonymizedBytes,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(widget.backPath),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        ListTile(
          title: Text(L10n.of(context).postBackPhotoGanonymize),
          trailing: Switch(
            value: _isGanonymize,
            onChanged: (value) {
              setState(() {
                _isGanonymize = value;
              });
              if (value && _ganonymizedBytes == null) {
                _ganonymize();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFrontPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: Text(
            L10n.of(context).postSmilePhoto,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16),
          child: Container(
            width: 200,
            height: 200,
            child: _uploadSmilePhoto
                ? Image.file(
                    File(widget.frontPath),
                    fit: BoxFit.cover,
                  )
                : Container(color: Colors.grey),
          ),
        ),
        SimpleDialogOption(
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text(L10n.of(context).postDeleteFrontPhoto),
          ),
          onPressed: () {
            _showDiscardPhotoDialog();
          },
        ),
      ],
    );
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(L10n.of(context).postDiscardDialogTitle),
          content: Text(L10n.of(context).postDiscardDialogMessage),
          actions: <Widget>[
            TextButton(
                child: Text(L10n.of(context).postDiscardDialogCancel),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text(L10n.of(context).postDiscardDialogDiscard,
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _dismiss();
                }),
          ],
        );
      },
    );
  }

  void _showDiscardPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(L10n.of(context).postDeleteFrontPhoto),
          content: Text(L10n.of(context).postDeleteFrontPhotoDialogMessage),
          actions: <Widget>[
            TextButton(
                child: Text(L10n.of(context).postDiscardDialogCancel),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text(L10n.of(context).postDeleteDialogDelete,
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(
                    () {
                      Navigator.pop(context);
                      _uploadSmilePhoto = false;
                    },
                  );
                }),
          ],
        );
      },
    );
  }

  Future _ganonymize() async {
    setState(() {
      _ganonymizing = true;
    });

    final backBytes = File(widget.backPath).readAsBytesSync();

    final backImage = ImageUtil.decodeImage(backBytes);
    final resizedImage = ImageUtil.copyResize(backImage, width: 1080);
    final resizedBytes = ImageUtil.encodeJpg(resizedImage, quality: 50);
    final result = await GanonymizerAPI.shared.ganonymize(resizedBytes);
    if (result.item1 != null) {
      final resultBytes = base64.decode(result.item1);
      setState(() {
        _ganonymizing = false;
        _ganonymizedBytes = resultBytes;
      });
    } else {
      setState(() {
        _ganonymizing = false;
      });
    }
  }

  Future _upload() async {
    FocusScope.of(context).unfocus();

    if (_uploading || _ganonymizing) return;
    setState(() {
      _uploading = true;
    });

    Uint8List frontBytes;
    if (_uploadSmilePhoto) {
      final front = await FlutterImageCompress.compressWithFile(
        widget.frontPath,
        quality: 40,
        minHeight: 1080,
      );
      frontBytes = Uint8List.fromList(front);
    } else {
      frontBytes = null;
    }

    final back = await FlutterImageCompress.compressWithFile(
      widget.backPath,
      quality: 40,
      minHeight: 1080,
    );
    final backBytes =
        _isGanonymize ? _ganonymizedBytes : Uint8List.fromList(back);

    final groupIds = [widget.theme.id];
    final location = await Location().getLocation();
    final lat = location.latitude;
    final lon = location.longitude;

    final result = await SmileAPI.shared.postSmile(
      frontBytes,
      backBytes,
      groupIds,
      _caption,
      lat,
      lon,
    );

    setState(() {
      _uploading = false;
    });

    if (!result.item1) {
      final snackbar = SnackBar(
        content: Text(result.item2),
        backgroundColor: Colors.red,
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      SoxAPI.shared.postSmile(
        backBytes,
        widget.smilingProbability,
        lat,
        lon,
      );
      PointManager.shared.showPointNotification(PointUsage.post);
      if (_uploadSmilePhoto) {
        PointManager.shared.showPointNotification(PointUsage.post_smile);
      }
      if (_isGanonymize) {
        PointManager.shared.showPointNotification(PointUsage.ganonymize);
      }
    }

    _dismiss();
  }

  void _dismiss() {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }
}
