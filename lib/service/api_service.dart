import 'package:flutter_europe_info/models/country_model.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://restcountries.com/v3.1/region/europe?fields=name,capital,flags,region,languages,population,capital")
abstract class ApiService{
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("")
  Future<List<CountryModel>> getCountryInfo();
}