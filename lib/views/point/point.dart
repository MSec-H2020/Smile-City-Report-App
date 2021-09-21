import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smile_x/controller/api/user_api.dart';

import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/coupon.dart';
import 'package:smile_x/model/point.dart';
import 'package:smile_x/model/user.dart';
import 'coupon.dart';
import 'dart:convert';

class PointController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PointControllerState();
}

class PointControllerState extends State<PointController> {
  // Property
  List<CouponUse> coupons = [];
  String _icon;
  String _name;
  PointSummary _pointSummary;
  bool _loading = false;

  @override
  void initState() {
    // Invoke super
    super.initState();

    setState(() {
      _loading = true;
    });

    getPrefs(PrefsKey.Nickname).then((name) {
      setState(() {
        _name = name;
      });
    });

    getPrefs(PrefsKey.Icon).then((icon) {
      setState(() {
        _icon = icon;
      });
    });

    UserAPI.shared.fetchPointSummary().then((result) {
      if (!result.item2) {
        setState(() {
          _loading = false;
        });
        showErrorDialog(context, result.item3);
      } else {
        setState(() {
          _loading = false;
          _pointSummary = result.item1;
        });
      }
    });
  }

  Widget _bodyForStatus() {
    if (_pointSummary == null) {
      return Center(child: Text(L10n.of(context).pointNoData));
    } else {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            profileView(),
            rivalView(),
            //couponView()
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).pointTitle)),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: _bodyForStatus(),
      ),
    );
  }

  Widget couponView() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Text(
              L10n.of(context).pointCouponViewTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: FlatButton(
              child: Text(L10n.of(context).pointCouponViewMore),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CouponController())),
            ),
          ),
          Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  final coupon = coupons[index];
                  return Card(
                      elevation: 2.0,
                      margin: EdgeInsets.only(right: 5, left: 5),
                      child: Container(
                        margin: EdgeInsets.all(0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 120,
                              width: 120,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    'https://www.ht.sfc.keio.ac.jp/~eigen/debug_images/b.jpg',
                              ),
                            ),
                            Text(coupon.coupon.title),
                            Text(coupon.coupon.description),
                            Text(L10n.of(context).pointRequiredPoint(coupon.coupon.point.toString())),
                          ],
                        ),
                      ));
                },
              ))
        ],
      ),
    );
  }

  Widget rivalView() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Text(
              L10n.of(context).pointRivalViewTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            //trailing: Text('もっとみる'),
          ),
          Container(
              height: 165,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    _pointSummary == null ? 0 : _pointSummary.rivals.length,
                itemBuilder: (context, index) {
                  final rival = _pointSummary.rivals[index];
                  return _buildRivalView(rival);
                },
              ))
        ],
      ),
    );
  }

  Widget _buildRivalView(User rival) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(right: 5, left: 5, bottom: 5),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(rival.iconUrl),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                rival.nickname,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(rival.allPoints.toString()),
            ),
            Container(
              child: Text(L10n.of(context).pointRivalViewToday +
                  rival.todayPoints.toString()),
            )
          ],
        ),
      ),
    );
  }

  Widget profileView() {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Photos
              Container(
                margin: EdgeInsets.only(top: 10, left: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      child: CircleAvatar(
                        backgroundImage: _icon != null
                            ? Image.memory(base64.decode(_icon)).image
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        _name != null ? _name : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(L10n.of(context).pointProfileViewRankingTitle),
                    Text(
                      _pointSummary == null
                          ? ''
                          : L10n.of(context).pointProfileViewRanking(
                              _pointSummary.rank.toString()),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    Text(
                      _pointSummary == null
                          ? ''
                          : L10n.of(context).pointProfileViewRankingMemberCount(
                              _pointSummary.participants.toString()),
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Container(
            margin: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(L10n.of(context).pointProfileViewPoint),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        _pointSummary == null
                            ? ''
                            : _pointSummary.allPoints.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(L10n.of(context).pointProfileViewToday),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        _pointSummary == null
                            ? ''
                            : _pointSummary.todayPoints.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
