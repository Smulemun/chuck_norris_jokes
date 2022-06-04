import 'dart:convert';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:chuck_jokes/joke.dart';
import 'package:chuck_jokes/image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const String _jokeAPI = 'https://api.chucknorris.io/jokes/random';
const String _imageAPI =
    "https://serpapi.com/search.json?engine=google&q=chuck+norris&google_domain=google.com&tbm=isch&ijn=0&api_key=0c1d759b8d4795a3c9f3847e923f3162bd873f3ba9fcd9a8f732a6d0fec1897b";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const Joke(),
    );
  }
}

class Joke extends StatefulWidget {
  const Joke({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JokeState();
}

class _JokeState extends State<Joke> {
  void _updateJoke() {
    setState(() {});
  }

  Future<Pair<JokeResponseModel, ImageResponseModel>> _getJokeAndImage() async {
    final results = await Future.wait(
        [http.get(Uri.parse(_jokeAPI)), http.get(Uri.parse(_imageAPI))]);

    return Pair(
      JokeResponseModel.fromJson(
          jsonDecode(results[0].body) as Map<String, Object?>),
      ImageResponseModel.fromJson(
          jsonDecode(results[1].body) as Map<String, Object?>),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx.abs() > 10) {
                    _updateJoke();
                  }
                },
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange,
                      width: 10,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: FutureBuilder(
                    future: _getJokeAndImage(),
                    builder: (context, snapshot) {
                      final data = snapshot.data
                          as Pair<JokeResponseModel, ImageResponseModel>?;
                      if (data == null) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              data.first.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(
                              data.last.toString(),
                              width: 400,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: _updateJoke,
                color: Colors.orangeAccent,
                iconSize: 100,
                icon: const Icon(Icons.thumb_up),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
