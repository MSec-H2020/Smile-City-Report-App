import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smile_x/l10n/l10n.dart';

enum IconType { user, theme }

class IconController extends StatefulWidget {
  final IconType type;

  IconController(this.type);

  @override
  State<StatefulWidget> createState() => IconControllerState();
}

class IconControllerState extends State<IconController> {
  // Property
  int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == IconType.user
            ? L10n.of(context).iconTitleProfile
            : L10n.of(context).iconTitleTheme),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done_outline),
            onPressed: iconAction,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 13,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(pathFor(widget.type, index)),
                          fit: BoxFit.cover,
                          colorFilter: _selectedIndex != index
                              ? null
                              : ColorFilter.mode(
                                  Colors.black54, BlendMode.dstATop),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: _selectedIndex != index
                            ? null
                            : Icon(
                                Icons.check,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text(L10n.of(context).iconFromCamera),
                      onPressed: () => get(ImageSource.camera),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text(L10n.of(context).iconFromAlbum),
                      onPressed: () => get(ImageSource.gallery),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  String pathFor(IconType type, int index) {
    switch (type) {
      case IconType.user:
        return 'assets/user/$index.jpg';
      case IconType.theme:
        return 'assets/theme/$index.jpg';
      default:
        return null;
    }
  }

  void iconAction() {
    Navigator.of(context).pop(pathFor(widget.type, _selectedIndex));
  }

  Future get(ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source);
    Navigator.of(context).pop(image);
  }
}
