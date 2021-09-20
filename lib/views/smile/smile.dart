import 'package:flutter/material.dart';
import 'package:smile_x/controller/preferences_manager.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/model/smile.dart';
import 'package:smile_x/utils/utils.dart';

class SmileController extends StatefulWidget
{
  final Smile smile;

  SmileController({this.smile});

  @override
  State<StatefulWidget> createState() => SmileControllerState();
}

class SmileControllerState extends State<SmileController>
{
  // Property
  String _icon;
  int _userId;

  List<Smile> _smiles = [];

  @override
  void initState()
  {
    // Invoke super
    super.initState();

    getPrefs(PrefsKey.Icon).then((icon) {
      setState(() {
        _icon = icon;
      });
    });

    getPrefs(PrefsKey.UserId).then((uId) {
      setState(() {
        _userId = int.tryParse(uId);
      });
    });

    setState(() {
      _smiles = [widget.smile];
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).smileTitle),
      ),
      body: smileListView(context, _smiles, _icon, _userId),
    );
  }
}