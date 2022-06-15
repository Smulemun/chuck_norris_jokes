import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class ImageResponseModel {
  static var rng = Random();
  static int index = 0;
  @JsonKey(name: 'images_results')
  final List<Images> imagesResults;

  ImageResponseModel(this.imagesResults);

  factory ImageResponseModel.fromJson(Map<String, dynamic> json) {
    index = rng.nextInt(100);
    return _$ImageResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ImageResponseModelToJson(this);

  @override
  String toString() => imagesResults[index].toString();
}

@JsonSerializable()
class Images {
  final String thumbnail;

  Images(this.thumbnail);

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);

  @override
  String toString() => thumbnail;
}
