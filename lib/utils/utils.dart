import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smile_x/controller/api/smile_api.dart';
import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/controller/request_manager.dart';
import 'package:smile_x/l10n/l10n.dart';

import 'package:smile_x/model/smile.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/views/timeline/detail.dart';
import 'package:smile_x/views/comment/comment_list.dart';

import 'dart:convert';

import 'package:aws_translate/aws_translate.dart';

enum Status { loading, fetched, no_data }

enum GroupStatus { nothing, create, update }

String diffFor(BuildContext context, String dateString) {
  final datetime = DateTime.tryParse(dateString);
  if (datetime == null) {
    return '';
  }
  final diff = DateTime.now().difference(datetime);
  if (diff.inDays != 0) {
    return L10n.of(context).utilsDiffInDays(diff.inDays.toString());
  } else if (diff.inHours != 0) {
    return L10n.of(context).utilsDiffInHours(diff.inHours.toString());
  } else if (diff.inMinutes != 0) {
    return L10n.of(context).utilsDiffInMinutes(diff.inMinutes.toString());
  } else {
    return L10n.of(context).utilsDiffInSeconds(diff.inSeconds.toString());
  }
}

Future<void> refresh() async {
  return;
}

Widget smileListView(BuildContext context, List<Smile> smiles, String icon, int userId, {Widget header, ScrollController controller, Future<void> Function() refreshAction = refresh}) {
  // Decide list length
  final count = (header == null) ? smiles.length : smiles.length + 1;

  return RefreshIndicator(
    onRefresh: refreshAction,
    child: smiles.isEmpty
        ? Column(
            children: <Widget>[
              header != null ? header : SizedBox(height: 30),
              Container(
                child: Center(
                  child: Text(L10n.of(context).utilsSmileListViewNoData),
                ),
              )
            ],
          )
        : Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  itemCount: count,
                  itemBuilder: (context, index) {
                    // For header
                    if (index == 0 && header != null) {
                      return header;
                    }
                    var smile = (header == null) ? smiles[index] : smiles[index - 1];
                    var width = MediaQuery.of(context).size.width;

                    return Column(
                      children: <Widget>[
                        // Image container
                        Container(
                          width: width,
                          height: width,
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl: smile.backPath,
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return DetailController(smile);
                              }));
                            },
                          ),
                        ),
                        _buildUserSection(context, smile),
                        _buildCaptionSection(context, smile.caption),
                        _buildSmiledLabel(context, smile),
                        InkWell(
                          child: _buildCommentSection(
                            context,
                            smile,
                            userId,
                            icon,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentListController(smile, icon)));
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16.0, bottom: 40),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            diffFor(context, smile.createdAt),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
  );
}

Widget _buildUserSection(BuildContext context, Smile smile) {
  return Container(
      height: 32,
      margin: EdgeInsets.only(left: 16, top: 16),
      child: Row(
        children: <Widget>[
          Container(width: 30, height: 30, child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(smile.user.iconUrl))),
          SizedBox(width: 8),
          Text(
            smile.user.nickname,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          IconButton(icon: Icon(Icons.more_horiz), onPressed: () => _showOptions(context, smile.id, smile.user)),
        ],
      ));
}

void _showOptions(BuildContext context, int smileId, User user) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(L10n.of(context).timelineReportPost),
              onTap: () {
                Navigator.of(context).pop();
                _showReportDialog(context, smileId);
              },
            ),
            ListTile(
              title: Text(L10n.of(context).timelineBlockUser),
              onTap: () {
                Navigator.of(context).pop();
                _showBlockDialog(context, user);
              },
            ),
          ],
        ));
      });
}

void _showReportDialog(BuildContext context, int smileId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(L10n.of(context).timelineReportPostDialogMessage),
        actions: <Widget>[
          TextButton(
              child: Text(L10n.of(context).postDiscardDialogCancel),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
              child: Text(L10n.of(context).timelineReportPost, style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                SmileAPI.shared.reportSmile(smileId).then((result) {
                  if (!result.item1) {
                    showErrorDialog(context, result.item2);
                  }
                });
              }),
        ],
      );
    },
  );
}

void _showBlockDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(L10n.of(context).timelineBlockUserDialogMessage),
        actions: <Widget>[
          TextButton(
              child: Text(L10n.of(context).postDiscardDialogCancel),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
              child: Text(L10n.of(context).timelineBlockUser, style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                UserAPI.shared.blockUser(user.id).then((result) {
                  if (!result.item1) {
                    showErrorDialog(context, result.item2);
                  }
                });
              }),
        ],
      );
    },
  );
}

Widget _buildCaptionSection(BuildContext context, String caption) {
  if (caption.isEmpty) {
    return Container();
  }
  return Container(
      //height: 64,
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: _TranslateCaption(caption),
        )
      ]));
}

Widget _buildSmiledLabel(BuildContext context, Smile smile) {
  if (smile.others?.length == 0) {
    return Container();
  }
  return Container(
    margin: EdgeInsets.only(top: 4.0, left: 16, bottom: 4.0),
    height: 28,
    alignment: Alignment.centerLeft,
    child: Text(
      L10n.of(context).utilsSmiledCount(smile.others?.length.toString()),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
    ),
  );
}

Widget _buildCommentSection(BuildContext context, Smile smile, int userId, String icon) {
  final myComments = smile.myComments(userId);
  return Column(
    children: <Widget>[
      Container(
        height: 24,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16),
              child: Text(
                L10n.of(context).utilsCommentCount(smile.comments.length.toString()),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
      myComments.length == 0
          ? Container(
              height: 32,
              margin: EdgeInsets.only(left: 16.0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    child: CircleAvatar(
                      backgroundImage: icon != null ? Image.memory(base64.decode(icon)).image : null,
                    ),
                  ),
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(L10n.of(context).utilsCommentPlaceholder),
                    ),
                  )
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.only(left: 16.0),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: myComments.first.user.nickname,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                      text: ' ' + myComments.first.text,
                    )
                  ],
                ),
              ),
            ),
      SizedBox(height: 10),
    ],
  );
}

class _TranslateCaption extends StatefulWidget {
  String caption;
  _TranslateCaption(this.caption);

  @override
  _TranslateCaptionState createState() => _TranslateCaptionState();
}

class _TranslateCaptionState extends State<_TranslateCaption> {
  String translatedText = '';
  bool disableButton = false;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextButton(
          child: Text(L10n.of(context).translateText),
          onPressed: disableButton
              ? null
              : () async {
                  setState(() {
                    disableButton = true;
                    translatedText = 'loading...';
                  });
                  AwsTranslate awsTranslate = AwsTranslate(poolId: 'ap-northeast-1:4db34ae9-7faf-44de-86ad-d332f101e101', region: Regions.AP_NORTHEAST_1);
                  Locale myLocale = Localizations.localeOf(context);
                  String translated = await awsTranslate.translateText(widget.caption, to: myLocale.languageCode);
                  if (!mounted) return;
                  setState(() => translatedText = translated);
                }),
      Visibility(visible: translatedText != '', child: Text(translatedText))
    ]);
  }
}
