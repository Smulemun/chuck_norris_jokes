// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joke.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JokeResponseModel _$JokeResponseModelFromJson(Map<String, dynamic> json) =>
    JokeResponseModel(
      json['value'] as String,
    );

Map<String, dynamic> _$JokeResponseModelToJson(JokeResponseModel instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

JokeList _$JokeListFromJson(Map<String, dynamic> json) => JokeList(
      (json['result'] as List<dynamic>)
          .map((e) => JokeResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JokeListToJson(JokeList instance) => <String, dynamic>{
      'result': instance.result,
    };
