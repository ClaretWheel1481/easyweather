import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

/// A user-selected city that identifies a weather query and cache entry.
@JsonSerializable()
class City {
  final String name;
  final String? admin;
  final String country;
  final double lat;
  final double lon;

  const City({
    required this.name,
    this.admin,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);

  String get cacheKey => 'weather_${lat}_$lon';

  @override
  String toString() => '$name${admin != null ? '·$admin' : ''}·$country';
}
