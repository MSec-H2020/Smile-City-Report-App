import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smile_x/controller/point_manager.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/comment.dart';

import 'package:smile_x/model/smile.dart';
import 'package:smile_x/utils/utils.dart';
import 'package:smile_x/controller/api/smile_api.dart';

import 'dart:convert';

class CommentListController extends StatefulWidget {
  final Smile smile;
  final String icon;

  CommentListController(this.smile, this.icon);

  @override
  State<StatefulWidget> createState() => CommentListControllerState();
}

class CommentListControllerState extends State<CommentListController> {
  // Property
  String comment;
  List<Comment> comments = [];
  TextEditingController _controller = TextEditingController();
  bool _posting = false;
  ImageProvider _image;

  @override
  void initState() {
    super.initState();
    comments = widget.smile.comments;
    if (widget.icon != null) {
      _image = Image.memory(base64.decode(widget.icon)).image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).commentTitle),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _posting,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: comments.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return commentTile(
                        widget.smile.caption,
                        widget.smile.user.iconUrl,
                        widget.smile.createdAt,
                        widget.smile.user.nickname);
                  } else if (index == 1) {
                    return Divider(
                      thickness: 1,
                    );
                  } else {
                    final comment = comments[index - 2];
                    return commentTile(comment.text, comment.user.iconUrl,
                        comment.createdAt, comment.user.nickname);
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                          backgroundImage: widget.icon != null ? _image : null,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          style: TextStyle(height: 1.0),
                          decoration: InputDecoration(
                            hintText: L10n.of(context).commentPlaceholder,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          onChanged: (text) {
                            setState(() {
                              comment = text;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        color: Colors.blue,
                        icon: Icon(Icons.send),
                        onPressed: comment == null || comment.isEmpty
                            ? null
                            : commentAction,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget emojiButton(String text) {
    return Container(
        width: 40,
        child: FlatButton(
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            final t = comment == null ? text : comment + text;
            comment = t;
            _controller.text = t;
          },
        ));
  }

  Future commentAction() async {
    setState(() {
      _posting = true;
    });
    final r = await SmileAPI.shared.postCommentFor(widget.smile.id, comment);
    if (!r.item2) {
      setState(() {
        _posting = false;
      });
      showErrorDialog(context, r.item3);
    } else {
      setState(() {
        comments = r.item1;
        comment = '';
        _controller.clear();
        _posting = false;
      });

      PointManager.shared.showPointNotification(PointUsage.post_comment);
    }
  }

  Widget commentTile(String text, String icon, String timestamp, String name) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(icon),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(text),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(diffFor(context, timestamp)),
        ],
      ),
    );
  }
}
