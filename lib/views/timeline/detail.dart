import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/smile.dart';
import 'package:smile_x/model/user.dart';

class DetailController extends StatefulWidget {
  final Smile smile;

  DetailController(this.smile);

  @override
  State<StatefulWidget> createState() => DetailControllerState();
}

class DetailControllerState extends State<DetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).detailTitle),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          // smile photo
          _buildSmilePhoto(widget.smile.picPath),
          _buildUserSection(widget.smile.user),
          _buildCaption(widget.smile.caption),
        ],
      )),
    );
  }

  Widget _buildSmilePhoto(String url) {
    final _imageWidth = MediaQuery.of(context).size.width;
    if (url.isEmpty) {
      return Container();
    }

    return Container(
      width: _imageWidth,
      height: _imageWidth,
      child: CachedNetworkImage(
        imageUrl: widget.smile.picPath,
        fit: BoxFit.cover,
        placeholder: (context, text) {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildUserSection(User user) {
    return Container(
        height: 32,
        margin: EdgeInsets.only(left: 16, top: 16),
        child: Row(
          children: <Widget>[
            Container(
                width: 30,
                height: 30,
                child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.iconUrl))),
            SizedBox(width: 8),
            Text(
              user.nickname,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  Widget _buildCaption(String caption) {
    if (caption == null || caption.isEmpty) {
      return Container();
    }
    return ListTile(title: Text(caption));
  }
}
