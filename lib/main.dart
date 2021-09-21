import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smile_x/l10n/l10n.dart';
import 'views/tab/tab.dart';
import 'controller/preferences_manager.dart';
import 'views/login/consent.dart';
import 'package:overlay_support/overlay_support.dart';
import 'controller/point_manager.dart';
import 'package:firebase_core/firebase_core.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //Make sure you imported firebase_core

  // Decide home
  var userId = await getPrefs(PrefsKey.UserId);
  //final debugLogin = await checkDebugLogin();
  var home = userId != null ? TabBarController() : ConsentController();

  // Set point
  await PointManager.shared.fetchPointUsages();

  // FirebaseCrashlytics.instance.crash();

  runApp(
    OverlaySupport(
      child: MaterialApp(
        home: home,
        routes: {
          '/tab': (_) => TabBarController(),
        },
        navigatorKey: navigatorKey,
        localizationsDelegates: [
          const L10nDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('ja'),
          Locale('en'),
          Locale('es'),
        ],
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
