import 'package:json_annotation/json_annotation.dart';
part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
  Flags flags;
  Name name;
  List<String> capital;
  @JsonKey(fromJson: _regionFromJson, toJson: _regionToJson)
  Region region;
  Map<String, String>? languages;
  int? population;

  CountryModel({
    required this.flags,
    required this.name,
    required this.capital,
    required this.region,
    required this.languages,
    required this.population,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}

@JsonSerializable()
class Flags {
  String png;
  String svg;
  String alt;

  Flags({
    required this.png,
    required this.svg,
    required this.alt,
  });
  factory Flags.fromJson(Map<String, dynamic> json) => _$FlagsFromJson(json);
  Map<String, dynamic> toJson() => _$FlagsToJson(this);
}

@JsonSerializable()
class Name {
  String common;
  String official;
  Map<String, NativeName> nativeName;

  Name({
    required this.common,
    required this.official,
    required this.nativeName,
  });
  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);
  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class NativeName {
  String official;
  String common;

  NativeName({
    required this.official,
    required this.common,
  });
  factory NativeName.fromJson(Map<String, dynamic> json) =>
      _$NativeNameFromJson(json);
  Map<String, dynamic> toJson() => _$NativeNameToJson(this);
}

enum Region { EUROPE }

// Custom JSON serialization for Region enum
Region _regionFromJson(String region) {
  switch (region.toLowerCase()) {
    case 'europe':
      return Region.EUROPE;
    default:
      throw ArgumentError('Unknown region: $region');
  }
}

String _regionToJson(Region region) {
  return region.toString().split('.').last.toUpperCase();
}
