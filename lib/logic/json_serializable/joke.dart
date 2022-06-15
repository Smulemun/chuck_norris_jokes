import 'package:json_annotation/json_annotation.dart';

part 'joke.g.dart';

@JsonSerializable()
class JokeResponseModel {
  final String value;

  JokeResponseModel(this.value);

  factory JokeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$JokeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$JokeResponseModelToJson(this);

  @override
  String toString() => value;
}

@JsonSerializable()
class JokeList {
  final List<JokeResponseModel> result;

  JokeList(this.result);

  factory JokeList.fromJson(Map<String, dynamic> json) =>
      _$JokeListFromJson(json);

  Map<String, dynamic> toJson() => _$JokeListToJson(this);
}
