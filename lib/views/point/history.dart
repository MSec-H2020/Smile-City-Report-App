import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:smile_x/l10n/l10n.dart';

import 'package:smile_x/model/point.dart';

class PointUseHistoryController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PointUseHistoryControllerState();
}

class PointUseHistoryControllerState extends State<PointUseHistoryController> {
  @override
  Widget build(BuildContext context) {
    final pointUses = [
      PointUse(0, '', Point(0, -500, 'クーポン使用')),
      PointUse(0, '', Point(0, 100, 'いいね完了')),
      PointUse(0, '', Point(0, 200, '投稿完了')),
      PointUse(0, '', Point(0, 200, '投稿完了')),
      PointUse(0, '', Point(0, 100, '初回ログイン')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).pointUseHistoryTitle),
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
                  Text(L10n.of(context).pointUseHistoryPointBalance('100')),
                ],
              )),
          Expanded(
            child: ListView.separated(
              itemCount: pointUses.length,
              separatorBuilder: (_, __) => Divider(
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final use = pointUses[index];
                return ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text(use.point.reason),
                  subtitle: Text('1日前'),
                  trailing: Text(
                    use.point.point.toString(),
                    style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
