import 'package:firebase_database/firebase_database.dart';

const String imageAPI =
    "https://serpapi.com/search.json?engine=google&q=chuck+norris&google_domain=google.com&tbm=isch&ijn=0&api_key=0c1d759b8d4795a3c9f3847e923f3162bd873f3ba9fcd9a8f732a6d0fec1897b";
const String jokeAPIrandom = 'https://api.chucknorris.io/jokes/random';
const String jokeAPIcategory =
    'https://api.chucknorris.io/jokes/random?category=';
const jokeSearchAPI = 'https://api.chucknorris.io/jokes/search?query=';
const List<String> categories = [
  "random",
  "animal",
  "career",
  "celebrity",
  "dev",
  "explicit",
  "fashion",
  "food",
  "history",
  "money",
  "movie",
  "music",
  "political",
  "religion",
  "science",
  "sport",
  "travel"
];
late final DatabaseReference db;
