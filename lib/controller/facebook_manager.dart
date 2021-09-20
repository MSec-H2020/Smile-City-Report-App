import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smile_x/model/facebook_user.dart';

Future<FacebookUser> fetchFacebookUserWith(String token) async
{
  var response = await http.get('https://graph.facebook.com/v3.3/me?'
      'fields=name,first_name,last_name,email,'
      'gender,picture.width(720).height(720)&access_token=$token');
  var j = json.decode(response.body) as Map<String, dynamic> ?? null;
  return j == null ? null : FacebookUser.createFrom(j);
}

Future fetchFacebookFriends(String token) async
{
  var response = await http.get('https://graph.facebook.com/v3.3/me/friends?'
      'fields=name,id,'
      'picture.width(500).height(500)&access_token=$token');
  var j = json.decode(response.body) as Map<String, dynamic> ?? null;
}

Future<Uint8List> fetchFacebookIcon(String url) async
{
  var response = await http.get(url);
  return response.bodyBytes;
}