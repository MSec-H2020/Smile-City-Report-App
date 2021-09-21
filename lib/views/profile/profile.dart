import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/controller/api/user_api.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/views/smile/smile.dart';

enum Cell { profile, photos }

class ProfileController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileControllerState();
}

class ProfileControllerState extends State<ProfileController> {
  // Property-
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String _icon;
  String _name;
  User _user;
  bool _uploading = false;
  String _marketplaceUsername;
  String _marketplacePublicKey;
  TextEditingController _marketplaceUsernameInitialize;
  TextEditingController _marketplacePublicKeyInitialize;


  @override
  void initState() {
    super.initState();

    getPrefs(PrefsKey.Icon).then((icon) {
      setState(() {
        _icon = icon;
      });
    });

    getPrefs(PrefsKey.Nickname).then((name) {
      setState(() {
        _name = name;
      });
    });

    UserAPI.shared.fetchMe().then((user) {
      setState(() {
        _user = user;
      });
    });

    getPrefs(PrefsKey.MarketplaceUsername).then((marketplaceUsername) {
      setState(() {
        _marketplaceUsername = marketplaceUsername;
        _marketplaceUsernameInitialize = new TextEditingController(text: marketplaceUsername);
      });
    });



    getPrefs(PrefsKey.MarketplacePublicKey).then((marketplacePublicKey) {
      setState(() {
        _marketplacePublicKey = marketplacePublicKey;
        _marketplacePublicKeyInitialize = new TextEditingController(text: marketplacePublicKey);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(L10n.of(context).profileTitle),
      ),
      body: _user == null
          ? null
          : ModalProgressHUD(
              child: _contentView(),
              inAsyncCall: _uploading,
            ),
    );
  }

  Widget _contentView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([_profileView()]),
        ),
        SliverGrid(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          delegate: SliverChildListDelegate(_user.smiles.map((smile) {
            return GestureDetector(
              child: smile.backPath.isEmpty
                  ? Container(color: Colors.grey)
                  : CachedNetworkImage(
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
  }

  Widget _profileView() {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Photos
                Column(
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
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(L10n.of(context)
                          .profilePostCount(_user.smiles.length.toString())),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: OutlineButton(
                onPressed: imageAction,
                child: Text(L10n.of(context).profileEditIcon),
              ),
            ),
            Container(
              child: TextFormField(
                // obscureText: true,
                controller: _marketplaceUsernameInitialize,
                decoration: InputDecoration(
                  labelText: L10n.of(context).signupMarketplaceUsername,
                ),
                onChanged: (text) {
                  setState(() {
                    _marketplaceUsername= text;
                    setPrefs(PrefsKey.MarketplaceUsername, _marketplaceUsername);
                  });
                },
              ),
            ),

            Container(
              child: TextFormField(
                controller: _marketplacePublicKeyInitialize,
                decoration: InputDecoration(
                  labelText: L10n.of(context).signupMarketplacePublicKey,
                ),
                onChanged: (text) {
                  setState(() {
                    _marketplacePublicKey = text;
                    setPrefs(PrefsKey.MarketplacePublicKey, _marketplacePublicKey);
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: OutlineButton(
                onPressed: () async {
                  if (await canLaunch("https://blocksplace.com/register")) {
                    await launch("https://blocksplace.com/register");
                  }
                },
                child: Text(L10n.of(context).signupMarketplaceUser),
              ),
            ),
          ],
        ));
  }

  Future imageAction() async {
    // Choose source
    final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(L10n.of(context).profileEditIcon),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text(L10n.of(context).profileFromCamera),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                child: ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text(L10n.of(context).profileFromAlbum),
                ),
              )
            ],
          );
        });
    if (source == null) {
      return;
    }
    var image = await ImagePicker.pickImage(source: source);
    if (image == null) {
      return;
    }

    final imageWidth = 200.0;

    // Choose
    var upload = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(L10n.of(context).profileEditIconDialog),
            content: Container(
              width: imageWidth,
              height: imageWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.file(
                    image,
                    width: imageWidth,
                    height: imageWidth,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(L10n.of(context).profileEditIconDialogCancel),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text(L10n.of(context).profileEditIconDialogOk),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          );
        });

    if (!upload) {
      return;
    }

    setState(() {
      _uploading = true;
    });
    final bytes = await FlutterImageCompress.compressWithFile(image.path,
        quality: 40, minHeight: 540);
    final result =
        await UserAPI.shared.updateProfile(Uint8List.fromList(bytes));

    setState(() {
      _uploading = false;
    });

    if (!result.item1) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text(result.item2),
      ));
      return;
    }

    final icon = base64Encode(bytes);
    setPrefs(PrefsKey.Icon, icon);

    setState(() {
      _icon = icon;
    });

    _key.currentState.showSnackBar(SnackBar(
      content: Text(L10n.of(context).profileEditIconSuccess),
    ));
  }
}
