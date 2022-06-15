import 'dart:async';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../logic/api.dart';
import '../logic/consts.dart';
import 'favourites_screen.dart';
import '../logic/json_serializable/image.dart';
import '../logic/json_serializable/joke.dart';
import 'search_screen.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({Key? key, required this.fbApp}) : super(key: key);

  final FirebaseApp fbApp;

  @override
  State<StatefulWidget> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  String? joke;
  String? imageURL;
  Future<Pair<JokeResponseModel, ImageResponseModel>>? jokeAndImage;
  String category = 'random';
  bool _isFavorited = false;
  bool _hasInternet = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubstriction;

  @override
  void initState() {
    jokeAndImage = getJokeAndImage(category);
    super.initState();
    _connectivitySubstriction =
        Connectivity().onConnectivityChanged.listen(_updateConnection);
  }

  @override
  void dispose() {
    _connectivitySubstriction.cancel();
    super.dispose();
  }

  Future<void> _updateConnection(ConnectivityResult result) async {
    setState(() {
      if (result == ConnectivityResult.none) {
        _hasInternet = false;
      } else {
        _hasInternet = true;
      }
    });
  }

  void _updateJoke() {
    setState(() {
      jokeAndImage = getJokeAndImage(category);
      _isFavorited = false;
    });
  }

  Future<void> favouriteJoke() async {
    if (joke != null && imageURL != null) {
      final snapshot = await db.get();
      if (snapshot.value != null) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        for (final key in data.keys) {
          if (data[key]['joke'] == joke) {
            db.child(key).remove();
            setState(() {
              _isFavorited = false;
            });
            return;
          }
        }
      }
      setState(() {
        _isFavorited = true;
      });
      await db.push().set({'joke': joke, 'imageURL': imageURL});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      showAlertDialog(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinder with Chuck'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Favourites',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const FavouritesScreen()),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Search',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const SearchScreen()),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Category:'),
                  DropdownButton<String>(
                    value: category,
                    items: categories
                        .map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (dynamic x) {
                      setState(() {
                        category = x.toString();
                        _updateJoke();
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
                    future: jokeAndImage,
                    builder: (context, snapshot) {
                      final data = snapshot.data
                          as Pair<JokeResponseModel, ImageResponseModel>?;
                      if (data == null) {
                        return const CircularProgressIndicator();
                      }
                      joke = data.first.toString();
                      imageURL = data.last.toString();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              joke!,
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
                              imageURL!,
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: favouriteJoke,
                      color: Colors.orangeAccent,
                      iconSize: 50,
                      icon: (_isFavorited)
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border),
                    ),
                    IconButton(
                      onPressed: _updateJoke,
                      color: Colors.orangeAccent,
                      iconSize: 50,
                      icon: const Icon(Icons.thumb_up),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
