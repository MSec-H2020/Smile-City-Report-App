import 'dart:async';
import 'dart:core';
import "dart:math";

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/theme.dart';
import 'package:smile_x/views/post/post.dart';

class PhotoController extends StatefulWidget {
  final ReportTheme theme;

  PhotoController(this.theme);

  @override
  State<PhotoController> createState() => PhotoControllerState();
}

class PhotoControllerState extends State<PhotoController> {
  // Property
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    _initializeCamera(0);
    super.initState();
  }

  Future<void> _initializeCamera(int index) async {
    final cameras = await availableCameras();
    if (cameras.length > index) {
      _cameraController =
          CameraController(cameras[index], ResolutionPreset.medium);
      _initializeControllerFuture = _cameraController.initialize();
      setState(() {});
    } else {
      print("No camera available");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    final temp = await getTemporaryDirectory();
    final now = DateTime.now().millisecondsSinceEpoch;
    final path = temp.path + '/$now.png';
    await _cameraController.takePicture(path);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).photoTitle)),
      body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_cameraController);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt), onPressed: onPressed),
    );
  }

  Future onPressed() async {
    try {
      await _initializeControllerFuture;
      final backPath = await _takePicture();

      await _initializeCamera(1);
      await Future.delayed(Duration(milliseconds: 1000));
      await _initializeControllerFuture;
      final frontPath = await _takePicture();
      await _cameraController.startImageStream((image) async {
        _cameraController.stopImageStream();
        final faces = await faceDetection(image);
        double smilingProbability;
        if (faces.length > 0) {
          smilingProbability =
              faces.map((f) => f.smilingProbability).reduce(max) ?? 0;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostController(
              theme: widget.theme,
              frontPath: frontPath,
              backPath: backPath,
              smilingProbability: smilingProbability,
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Face>> faceDetection(CameraImage image) async {
    final metadata = FirebaseVisionImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
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
    );
    final visionImage =
        FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
    final options = FaceDetectorOptions(
        mode: FaceDetectorMode.accurate, enableClassification: true);
    final faceDetector = FirebaseVision.instance.faceDetector(options);
    return await faceDetector.processImage(visionImage);
  }
}
