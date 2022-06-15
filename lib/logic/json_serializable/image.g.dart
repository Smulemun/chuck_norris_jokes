// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageResponseModel _$ImageResponseModelFromJson(Map<String, dynamic> json) =>
    ImageResponseModel(
      (json['images_results'] as List<dynamic>)
          .map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageResponseModelToJson(ImageResponseModel instance) =>
    <String, dynamic>{
      'images_results': instance.imagesResults,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      json['thumbnail'] as String,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'thumbnail': instance.thumbnail,
    };
