import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:smile_x/controller/api/smile_api.dart';
import 'package:smile_x/controller/point_manager.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:location/location.dart';

import 'package:smile_x/model/smile.dart';
import 'package:smile_x/model/theme.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/utils/utils.dart';
import 'package:smile_x/controller/api/user_api.dart';

class TimelineController extends StatefulWidget {
  @override
  State<TimelineController> createState() => TimelineControllerState();
}

class TimelineControllerState extends State<TimelineController> {
  // Property
  String _icon;
  int _userId;

  List<ReportTheme> _themes = [];
  int _selectedIndex = 0;
  Status _status = Status.loading;
  int _selectedUserId;

  double _screenWidth = 400;
  double _memberViewHeight = 100.0;

  int _watchingSmileId;
  int _watchedSmileId;
  List<Face> _faces = [];
  bool enableDetection = true;
  List<int> _reactedSmileIds = [];

  ScrollController _scrollController = ScrollController();
  CameraController _controller;

  @override
  void initState() {
    // Invoke super
    super.initState();

    //LogAPI.shared.postLog('timeline');

    getPrefs(PrefsKey.Icon).then((icon) {
      setState(() {
        _icon = icon;
      });
    });

    getPrefs(PrefsKey.UserId).then((uId) {
      setState(() {
        _userId = int.tryParse(uId);
      });
    });

    print('fetchThemes()');
    // Fetch groups
    UserAPI.shared.fetchThemes().then((result) async {
      if (!result.item2) {
        showErrorDialog(context, result.item3);
        setState(() {
          _status = Status.no_data;
        });
      } else {
        setState(() {
          _themes = result.item1;

          _status = result.item1.length == 0 ? Status.no_data : Status.fetched;
        });

        // For no group
        if (result.item1.length == 0) {
          return;
        }

        // Set smile id
        final smiles = await result.item1[_selectedIndex]
            .smilesFilteredBy(_selectedUserId);
        if (smiles.length > 0) {
          _watchingSmileId = smiles.first.id;
        }

        // Start face detection in background
        await startBackgroundFaceDetection();

        await _requestLocationPermission();

        // Add listener to scroll controller
        _scrollController.addListener(scrollAction);
      }
    });

    // Post aware_id
    // getHasSendAwareId().then((value) {
    //   if (!value) {
    //     postAwareId();
    //   }
    // });
  }

  Future _requestLocationPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    print('location, _serviceEnabled');
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    print(_permissionGranted);
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void dispose() {
    // Invoke super
    super.dispose();

    // Stop face detection
    stopBackgroundFaceDetection();
  }

  void scrollAction() async {
    // Judge which row is displayed
    final index =
        (_scrollController.offset / (_screenWidth + _memberViewHeight)).round();

    // For no groups
    if (_themes.length == 0) {
      return;
    }

    // Update watching smile id
    final smiles =
        await _themes[_selectedIndex].smilesFilteredBy(_selectedUserId);
    if (index < smiles.length && index >= 0) {
      _watchingSmileId = smiles[index].id;
    }
  }

  Future startBackgroundFaceDetection() async {
    print('start detection');

    _reactedSmileIds = await getReactedSmileIds();

    // Enable detection
    enableDetection = true;

    // Create camera controller
    final cameras = await availableCameras();
    if (cameras.length == 0) {
      return;
    }
    _controller = CameraController(cameras[1], ResolutionPreset.medium);
    await _controller.initialize();
    if (Platform.isAndroid) {
      // add delay on android
      await Future.delayed(Duration(milliseconds: 400));
    }

    // Configure detection interval
    final interval = 1000;
    final maxCount = 15;
    var start = DateTime.now();

    // Start image stream
    _controller.startImageStream((image) async {
      final now = DateTime.now();
      if (now.millisecondsSinceEpoch - start.millisecondsSinceEpoch <
          interval) {
        return;
      }
      start = now;
      //print(_watchedSmileId);

      // Detect face every interval
      if (_watchingSmileId == null) {
        // print('no smile id');
        return;
      } else if (_reactedSmileIds.contains(_watchingSmileId)) {
        return;
      }

      final smileId = _watchingSmileId;
      final faces = await faceDetection(image);

      // For called it when camera dispose
      if (!enableDetection) {
        // print('camera already stopped');
        return;
      } else if (_reactedSmileIds.contains(_watchingSmileId)) {
        return;
      }

      // For no face
      if (faces.length == 0) {
        postSmile(_faces, _watchedSmileId);
        _watchedSmileId = null;
        _faces = [];
      } else {
        // For same smile
        final face = faces.first;

        //print(face.smilingProbability);
        if (_watchedSmileId == null || _watchedSmileId == smileId) {
          //print('same smile $smileId');
          _watchedSmileId = smileId;
          _faces.add(face);
          if (_faces.length >= maxCount) {
            print('stop detection');
            postSmile(_faces, _watchedSmileId);
            _faces = [];
            await stopBackgroundFaceDetection();
          }
        }
        // For other smile
        else {
          //print('changed smile $smileId');
          postSmile(_faces, _watchedSmileId);
          _faces = [];
          _watchedSmileId = smileId;
        }

        //print("smileId:" + smileId.toString() + "    probability:" + face.smilingProbability.toString());
        // Post face to server
        final result = await SmileAPI.shared.postSmileFor(
          smileId,
          face.smilingProbability,
          null,
          null,
        );
        //print("result:" + result.item1.toString() + "," + result.item2.toString());

        // Print result
        if (result.item1 && face.smilingProbability > 0.4) {
          _reactedSmileIds.add(smileId);
          PointManager.shared.showPointNotification(PointUsage.react_smile);
        } else {
          // print(result.item2);
        }
      }
    });
  }

  Future postSmile(List<Face> faces, int smileId) async {
    if (faces.length < 2) {
      return false;
    }
    final smiles = faces.map((face) => face.smilingProbability).toList();
    final first = smiles.first;
    smiles.sort((a, b) => b.compareTo(a));
    final max = smiles.first;

    final result = await SmileAPI.shared
        .postDiffDegreeFor(smileId, first, max, null, null);
    result.item1 ? print('posted othersmile $smileId') : print(result.item2);
  }

  Future stopBackgroundFaceDetection() async {
    print('stop detection');

    enableDetection = false;

    await setReactedSmileIds(_reactedSmileIds);

    // Dispose camera
    if (_controller == null) {
      return;
    }
    if (Platform.isAndroid) {
      // add delay on android
      await Future.delayed(Duration(milliseconds: 600));
    }
    await _controller.stopImageStream();
    if (Platform.isAndroid) {
      await Future.delayed(Duration(milliseconds: 600));
    }
    await _controller.dispose();
    if (Platform.isAndroid) {
      await Future.delayed(Duration(milliseconds: 600));
    }
    _controller = null;

    // Remove listener
    // _scrollController.removeListener(scrollAction);
  }

  Future<List<Face>> faceDetection(CameraImage image) async {
    // Create metadata
    final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
      rawFormat: image.format.raw,
      planeData: image.planes
          .map(
            (currentPlane) => FirebaseVisionImagePlaneMetadata(
              bytesPerRow: currentPlane.bytesPerRow,
              height: currentPlane.height,
              width: currentPlane.width,
            ),
          )
          .toList(),
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: ImageRotation.rotation270,
    );

    // Detect face
    final visionImage =
        FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
    final options = FaceDetectorOptions(
        mode: FaceDetectorMode.accurate, enableClassification: true);
    final faceDetector = FirebaseVision.instance.faceDetector(options);
    return await faceDetector.processImage(visionImage);
  }

  Future<void> refreshAction() async {
    final result = await UserAPI.shared.fetchThemes();
    if (!mounted) {
      return;
    }
    if (!result.item2) {
      showErrorDialog(context, result.item3);
    } else {
      setState(() {
        _themes = result.item1;
        _status = result.item1.length == 0 ? Status.no_data : Status.fetched;
      });
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
        widget = _themes.length == 0
            ? null
            : FutureBuilder<List<Smile>>(
                future: _themes[_selectedIndex].smiles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<Smile> smiles = snapshot.hasData ? snapshot.data : [];
                  if (_selectedUserId != null) {
                    smiles = smiles
                        .where((smile) => smile.userId == _selectedUserId)
                        .toList();
                  }
                  return smileListView(context, smiles, _icon, _userId,
                      header: _memberListView(),
                      controller: _scrollController,
                      refreshAction: refreshAction);
                },
              );
        break;
      case Status.no_data:
        widget = Center(
          child: Text(L10n.of(context).timelineNoTheme),
        );
        break;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _themes.isEmpty
            ? Text(L10n.of(context).timelineTitle)
            : GestureDetector(
                onTap: _groupDialog,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        L10n.of(context).timelineTitleWithTheme(
                            _themes[_selectedIndex].title),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
      ),
      body: _bodyForStatus(),
    );
  }

  Widget _memberListView() {
    return Container(
      height: _memberViewHeight,
      margin: EdgeInsets.only(top: 10),
      child: FutureBuilder<List<User>>(
        future: _themes[_selectedIndex].joining,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          final List<User> joining = snapshot.hasData ? snapshot.data : [];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _themes.length > 0 ? joining.length : 0,
            itemBuilder: (context, index) {
              var member = joining[index];
              var width = MediaQuery.of(context).size.width / 7;
              return Column(
                children: <Widget>[
                  // User image
                  Container(
                    width: width,
                    height: width,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: member.id == _selectedUserId
                        ? EdgeInsets.all(2.0)
                        : null,
                    decoration: BoxDecoration(
                        color: Colors.cyanAccent, shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        member.iconUrl,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedUserId =
                                _selectedUserId != member.id ? member.id : null;
                          });
                        },
                      ),
                    ),
                  ),

                  // User name text
                  Text(
                    member.nickname,
                    style: TextStyle(
                        fontWeight: member.id == _selectedUserId
                            ? FontWeight.bold
                            : null),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future _groupDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => RadioButtonDialog(
        initialValue: _selectedIndex,
        themes: _themes,
        onValueChange: (value) {
          setState(() {
            _selectedIndex = value;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

class RadioButtonDialog extends StatefulWidget {
  final int initialValue;
  final List<ReportTheme> themes;
  final void Function(int) onValueChange;

  const RadioButtonDialog({this.initialValue, this.themes, this.onValueChange});

  @override
  State createState() => new RadioButtonDialogState();
}

class RadioButtonDialogState extends State<RadioButtonDialog> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(L10n.of(context).timelineThemeSelectionDialogTitle),
      children: widget.themes.asMap().entries.map(
        (e) {
          int index = e.key;
          ReportTheme theme = e.value;
          return RadioListTile<int>(
            title: Text(theme.title),
            groupValue: _selectedIndex,
            onChanged: (value) {
              setState(() {
                _selectedIndex = value;
              });
              widget.onValueChange(value);
            },
            value: index,
          );
        },
      ).toList(),
    );
  }
}
