import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/smile.dart';
import 'package:smile_x/model/theme.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/views/post/camera.dart';
import 'package:smile_x/views/smile/smile.dart';

class ThemeDetailController extends StatefulWidget {
  final ReportTheme theme;
  final ThemeType type;

  ThemeDetailController(this.theme, this.type);

  @override
  State<StatefulWidget> createState() => ThemeDetailControllerState();
}

class ThemeDetailControllerState extends State<ThemeDetailController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).themeDetailTitle),
      ),
      body: FutureBuilder<List<Smile>>(
        future: widget.theme.smiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          final List<Smile> smiles = snapshot.hasData ? snapshot.data : [];
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  profileView(),
                  _buildCaption(),
                  smiles.isEmpty ? _buildNoDate() : Container(),
                ]),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                delegate: SliverChildListDelegate(smiles.map((smile) {
                  return GestureDetector(
                    child: CachedNetworkImage(
                      imageUrl: smile.backPath,
                      fit: BoxFit.cover,
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SmileController(
                              smile: smile,
                            ))),
                  );
                }).toList()),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoController(widget.theme),
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }

  Widget profileView() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      height: width / 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: width / 5,
            width: width / 5,
            color: Colors.grey[300],
            child: widget.theme.image == null
                ? null
                : CachedNetworkImage(
                    imageUrl: widget.theme.image,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.theme.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FutureBuilder<User>(
                  future: widget.theme.owner,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final name =
                        snapshot.hasData ? snapshot.data.nickname : '---';
                    return Text(L10n.of(context).themeDetailOwner(name));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Container(
      margin: EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: Text(widget.theme.message),
    );
  }

  Widget _buildNoDate() {
    return Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text(
          L10n.of(context).themeDetailNoData,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
