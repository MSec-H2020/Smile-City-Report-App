import 'dart:async';
import 'package:dio/dio.dart';
import '../request_manager.dart';
import 'package:tuple/tuple.dart';
import 'package:smile_x/controller/preferences_manager.dart';


class LogAPI
{
  // -------------------------------------//
  //  -- Initialize --
  //--------------------------------------//

  static final shared = LogAPI._internal();

  factory LogAPI()
  {
    return shared;
  }

  LogAPI._internal();

  // -------------------------------------//
  //  -- API --
  //--------------------------------------//

  Future<bool> postLog(String view) async
  {
    final userId = await getPrefs(PrefsKey.UserId);
    if (userId == null) return false;

    Map<String, dynamic> params = {'user_id': userId, 'view': view};
    final result = await post('/logs', params);
    return result.item2;
  }
}