import 'package:flutter/material.dart';

import '../logic/api.dart';
import '../logic/consts.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Jokes'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getFavourites(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as Map<String, dynamic>;
              return ListView(
                children: data.keys.map((e) {
                  return Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            data[e]['joke'],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.network(
                            data[e]['imageURL'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: IconButton(
                            onPressed: () {
                              db.child(e).remove();
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
