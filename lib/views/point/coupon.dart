import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:smile_x/l10n/l10n.dart';

import 'package:smile_x/model/coupon.dart';

import 'history.dart';

class CouponController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CouponControllerState();
}

class CouponControllerState extends State<CouponController> {
  // Property
  List<CouponUse> couponUses = [];

  @override
  void initState() {
    // Invoke super
    super.initState();

    couponUses = [
      CouponUse(
          1,
          true,
          '',
          Coupon(
            1,
            'title',
            'description',
            100,
            'https://www.ht.sfc.keio.ac.jp/~eigen/debug_images/b.jpg',
          )),
      CouponUse(
          1,
          false,
          '',
          Coupon(
            1,
            'title',
            'description',
            100,
            'https://www.ht.sfc.keio.ac.jp/~eigen/debug_images/b.jpg',
          )),
      CouponUse(
          1,
          false,
          '',
          Coupon(
            1,
            'title',
            'description',
            120,
            'https://www.ht.sfc.keio.ac.jp/~eigen/debug_images/b.jpg',
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).couponTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PointUseHistoryController())),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          'https://www.ht.sfc.keio.ac.jp/~eigen/debug_images/a.jpg'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(L10n.of(context).couponPointBalance('100')),
                ],
              )),
          Expanded(
            child: couponListView(),
          )
        ],
      ),
    );
  }

  Widget couponListView() {
    return ListView.builder(
      itemCount: couponUses.length,
      itemBuilder: (context, index) {
        final couponUse = couponUses[index];
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.only(right: 32, left: 32, bottom: 20),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  child: CachedNetworkImage(
                    imageUrl: couponUse.coupon.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(couponUse.coupon.title),
                Text(couponUse.coupon.description),
                Text(
                  L10n.of(context)
                      .couponRequiredPoint(couponUse.coupon.point.toString()),
                ),
                couponButton(couponUse),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget couponButton(CouponUse coupon) {
    if (coupon.isUsed) {
      return RaisedButton(
        disabledColor: Colors.black12,
        shape: StadiumBorder(),
        child: Text(
          L10n.of(context).couponUsed,
        ),
        onPressed: null,
      );
    }
    // Fetch user point
    final point = 100;

    if (point >= coupon.coupon.point) {
      return RaisedButton(
        color: Colors.blue,
        shape: StadiumBorder(),
        child: Text(
          L10n.of(context).couponUse,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(L10n.of(context).couponUseDialogTitle),
                content: Text(L10n.of(context).couponUseDialogMessage),
                actions: <Widget>[
                  FlatButton(
                    child: Text(L10n.of(context).couponUseDialogCancel),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                    child: Text(L10n.of(context).couponUseDialogOk),
                    onPressed: () => Navigator.of(context).pop(true),
                  )
                ],
              );
            },
          );
          if (result == null) return;
          if (!result) return;
          // Use coupon
        },
      );
    } else {
      return RaisedButton(
        disabledColor: Colors.black12,
        shape: StadiumBorder(),
        child: Text(L10n.of(context).couponLackPoint),
        onPressed: null,
      );
    }
  }
}
