import 'package:flutter/material.dart';

import '../logic/api.dart';
import '../logic/json_serializable/joke.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  Future<JokeList>? jokeList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Jokes'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "Search",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.text.characters.length >= 3 &&
                        controller.text.characters.length <= 120) {
                      setState(() {
                        jokeList = getJokesList(controller.text);
                      });
                    }
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            SizedBox(
                height: 250,
                child: FutureBuilder(
                  future: jokeList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = (snapshot.data as JokeList).result;
                      if (data.isNotEmpty) {
                        return ListView(
                          children: data.map((e) {
                            return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: 200,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      e.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ));
                          }).toList(),
                        );
                      }
                      return const Center(
                        child: Text('no matches'),
                      );
                    }
                    return const Center(
                      child: Text('no matches'),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
