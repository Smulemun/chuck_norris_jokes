import 'dart:convert';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'json_serializable/image.dart';
import 'json_serializable/joke.dart';
import 'consts.dart';

Future<Pair<JokeResponseModel, ImageResponseModel>> getJokeAndImage(
    String category) async {
  final List<http.Response> results;
  if (category != 'random') {
    results = await Future.wait([
      http.get(Uri.parse(jokeAPIcategory + category)),
      http.get(Uri.parse(imageAPI))
    ]);
  } else {
    results = await Future.wait(
        [http.get(Uri.parse(jokeAPIrandom)), http.get(Uri.parse(imageAPI))]);
  }

  return Pair(
    JokeResponseModel.fromJson(
        jsonDecode(results[0].body) as Map<String, Object?>),
    ImageResponseModel.fromJson(
        jsonDecode(results[1].body) as Map<String, Object?>),
  );
}

Future<JokeList> getJokesList(String searchText) async {
  final result = await http.get(Uri.parse(jokeSearchAPI + searchText));
  return JokeList.fromJson(jsonDecode(result.body) as Map<String, Object?>);
}

Future<Map<String, dynamic>> getFavourites() async {
  final snapshot = await db.get();
  Map<String, dynamic> data = {};
  if (snapshot.value != null) {
    data = Map<String, dynamic>.from(snapshot.value as Map);
  }
  return data;
}

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text('No Internet Connection'),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit'),
          )
        ],
      );
    },
  );
}
