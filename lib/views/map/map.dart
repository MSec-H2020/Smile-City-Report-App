import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smile_x/controller/request_manager.dart';

import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/smile.dart';
import 'package:smile_x/model/theme.dart';
import 'package:smile_x/utils/utils.dart';
import 'package:smile_x/views/smile/smile.dart';

class MapController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapControllerState();
}

class MapControllerState extends State<MapController> {
  // Property
  Completer<GoogleMapController> _controller = Completer();
  List<ReportTheme> _themes = [];

  Set<Marker> _markers = Set<Marker>();

  LocationData _data;

  @override
  void initState() {
    // Invoke super
    super.initState();

    //LogAPI.shared.postLog('map');

    UserAPI.shared.fetchThemes().then((result) async {
      if (!result.item2) {
        showErrorDialog(context, result.item3);
      } else {
        if (result.item1.length == 0) {
          return;
        }

        _themes = result.item1;

          List<Smile> allSmiles = [];
          // Filter no gps
          await Future.forEach(_themes, (element) async {
            final smiles = await element.smiles;
            allSmiles.addAll(smiles);
          });

          final List<Smile> smiles = allSmiles.where((smile) {
            return smile.lat != 0 && smile.lon != 0;
          }).toList();

          final markers = smiles.map((smile) {
            return Marker(
              markerId: MarkerId(smile.id.toString()),
              position: LatLng(smile.lat, smile.lon),
              infoWindow: InfoWindow(
                title: diffFor(context, smile.createdAt),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SmileController(
                        smile: smile,
                      ),
                    ),
                  );
                },
              ),
            );
          }).toSet();

        setState(() {
          _markers = markers;
        });
      }
    });

    Location().getLocation().then((data) {
      setState(() {
        _data = data;
      });
    });
  }

//  Future<BitmapDescriptor> _icon(String url) async
//  {
//    Completer<BitmapDescriptor> bitmapIcon = Completer();
//    CachedNetworkImageProvider(url).resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo image, bool sync) async {
//      final bytes = await image.image.toByteData();
//      final bitmap = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
//      bitmapIcon.complete(bitmap);
//    }));
//
//    return await bitmapIcon.future;
//  }

  Widget _bodyForLocation() {
    if (_data == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            //target: LatLng(35.397284, 139.466587),
            target: LatLng(_data.latitude, _data.longitude),
            zoom: 15),
        onMapCreated: (controller) => _controller.complete(controller),
        markers: _markers,
        myLocationEnabled: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).mapTitle),
      ),
      body: _bodyForLocation(),
    );
  }
}
