import 'package:flutter/material.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'package:smile_x/views/login/signup.dart';

class ConsentController extends StatefulWidget {
  @override
  State<ConsentController> createState() => ConsentControllerState();
}

class ConsentControllerState extends State<ConsentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).consentTitle),
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  margin: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 240,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Text(L10n.of(context).consentText),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 8),
                      child: RaisedButton(
                        child: Text(L10n.of(context).consentReject),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(L10n.of(context).consentDialogTitle),
                              content:
                                  Text(L10n.of(context).consentDialogMessage),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(L10n.of(context).consentDialogOk),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 8, right: 20),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(L10n.of(context).consentAgree,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => SignUpController(),
                          ),
                        );
                      },
                    ),
                  ))
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
