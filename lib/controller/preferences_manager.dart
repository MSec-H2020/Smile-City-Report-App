import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile_x/model/user.dart';

enum PrefsKey {
  FacebookId,
  Icon,
  Nickname,
  FacebookEmail,
  UserId,
  IconUrl,
  StudentId,
  MarketplaceUsername,
  MarketplacePublicKey,
}

String strFor(PrefsKey key) {
  var keyStr = "";
  switch (key) {
    case PrefsKey.Icon:
      keyStr = "facebookIcon";
      break;
    case PrefsKey.FacebookId:
      keyStr = "facebookId";
      break;
    case PrefsKey.Nickname:
      keyStr = "nickname";
      break;
    case PrefsKey.FacebookEmail:
      keyStr = "facebookeEmail";
      break;
    case PrefsKey.UserId:
      keyStr = "user_id";
      break;
    case PrefsKey.IconUrl:
      keyStr = "icon_url";
      break;
    case PrefsKey.StudentId:
      keyStr = 'student_id';
      break;
    case PrefsKey.MarketplaceUsername:
      keyStr = 'marketplace_user_name';
      break;
    case PrefsKey.MarketplacePublicKey:
      keyStr = 'marketplace_public_key';
      break;
  }
  return keyStr;
}

Future<String> getPrefs(PrefsKey key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(strFor(key));
}

Future setPrefs(PrefsKey key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(strFor(key), value);
}

Future<UserRoll> getCurrentUserRoll() async {
  final prefs = await SharedPreferences.getInstance();
  final index = prefs.getInt('user_roll');
  if (index == null) {
    return UserRoll.student;
  }
  return UserRoll.values[index] ?? UserRoll.student;
}

Future setUserRoll(UserRoll roll) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('user_roll', roll.index);
}

Future<List<int>> getUserClasses() async {
  final prefs = await SharedPreferences.getInstance();
  final stringList = prefs.getStringList('user_classes') ?? [];
  return stringList.map((e) => int.parse(e)).toList();
}

Future setUserClasses(List<int> classes) async {
  final prefs = await SharedPreferences.getInstance();
  final stringList = classes.map((e) => e.toString()).toList();
  prefs.setStringList('user_classes', stringList);
}

Future<bool> getHasInitializedAware() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_initialized_aware') ?? false;
}

Future setHasInitializedAware(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('has_initialized_aware', value);
}

Future<bool> getEnabledPedometerRecognition() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('enabled_pedometer_recognition') ?? true;
}

Future setEnabledPedometerRecognition(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('enabled_pedometer_recognition', value);
}

Future<bool> getEnabledActivityRecognition() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('enabled_activity_recognition') ?? true;
}

Future setEnabledActivityRecognition(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('enabled_activity_recognition', value);
}

Future debugLogin() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('debug_login', true);
}

Future<bool> checkDebugLogin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('debug_login');
}

Future setHasSendAwareId(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('has_send_aware_id', value);
}

Future<bool> getHasSendAwareId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_send_aware_id') ?? false;
}

Future setHasOpendPointAchivedURL(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('has_opened_point_achived_url', value);
}

Future<bool> getHasOpendPointAchivedURL() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_opened_point_achived_url') ?? false;
}

Future<List<int>> getReactedSmileIds() async {
  final prefs = await SharedPreferences.getInstance();
  final stringList = prefs.getStringList('reacted_smile_ids') ?? [];
  return stringList.map((e) => int.parse(e)).toList();
}

Future setReactedSmileIds(List<int> classes) async {
  final prefs = await SharedPreferences.getInstance();
  final stringList = classes.map((e) => e.toString()).toList();
  prefs.setStringList('reacted_smile_ids', stringList);
}
