import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';

Options options() {
  // return Options(headers: {'Seed': 'ELKqtGUEJZEkt75O6NnhOBeSl4gumSgw'});
  return Options(headers: {'Seed': 'e4e0ffa57d2fc5159dc45e89031bd1ed'});
}

// final _baseUrl = 'http://minami.jn.sfc.keio.ac.jp:3000/api';
final _baseUrl = 'https://api.sfcity.io/api';

Future<Tuple3<Map<String, dynamic>, bool, String>> fetch(
    String endpoint, Map<String, dynamic> params) async {
  final path = _baseUrl + endpoint;
  try {
    final res =
        await Dio().get(path, queryParameters: params, options: options());
    return parse(res.data);
  } on DioError catch (e) {
    if (e.response.statusCode == 500)
      return Tuple3(null, false, 'Internal Server error');
    return e.response != null
        ? parse(e.response.data)
        : Tuple3(null, false, e.message);
  }
}

Future<Tuple3<Map<String, dynamic>, bool, String>> post(
    String endpoint, Map<String, dynamic> params,
    [String customBaseUrl]) async {
  // Post request
  final path = (customBaseUrl ?? _baseUrl) + endpoint;
  var data = FormData.fromMap(params);
  try {
    final res = await Dio().post(path, data: data, options: options());
    return parse(res.data);
  } on DioError catch (e) {
    print(e);
    if (e.response.statusCode == 500)
      return Tuple3(null, false, 'Internal Server error');
    return e.response != null
        ? parse(e.response.data)
        : Tuple3(null, false, e.message);
  }
}

Future<Tuple3<Map<String, dynamic>, bool, String>> soxpost(
    String endpoint, Map<String, dynamic> params,
    [String customBaseUrl]) async {
  // Post request
  final path = customBaseUrl + endpoint;
  try {
    final res = await Dio().post(path,
        data: jsonEncode(params),
        options: Options(headers: {'Content-Type': 'application/json'}));
    return parse(res.data);
  } on DioError catch (e) {
    print(e);
    print(e.response.statusCode);
    print(e.response.data);
    if (e.response.statusCode == 500)
      return Tuple3(null, false, 'Internal Server error');
    return e.response != null
        ? parse(e.response.data)
        : Tuple3(null, false, e.message);
  }
}

Future<Tuple3<Map<String, dynamic>, bool, String>> delete(
    String endpoint, Map<String, dynamic> params) async {
  final path = _baseUrl + endpoint;
  try {
    final res =
        await Dio().delete(path, queryParameters: params, options: options());
    return parse(res.data);
  } on DioError catch (e) {
    if (e.response.statusCode == 500)
      return Tuple3(null, false, 'Internal Server error');
    return e.response != null
        ? parse(e.response.data)
        : Tuple3(null, false, e.message);
  }
}

// For cast
T cast<T>(x) => x is T ? x : null;

Tuple3<Map<String, dynamic>, bool, String> parse(dynamic json) {
  final j = cast<Map<String, dynamic>>(json);
  if (j == null) return Tuple3(null, false, 'no data');
  final data =
      j.containsKey('data') ? cast<Map<String, dynamic>>(json['data']) : null;
  final result = j.containsKey('result') ? cast<bool>(json['result']) : null;
  final error = j.containsKey('error') ? cast<String>(json['error']) : null;
  return Tuple3(data, result, error);
}

showErrorDialog(BuildContext context, String error) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      });
}
