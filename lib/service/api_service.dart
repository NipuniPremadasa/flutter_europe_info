import 'package:flutter_europe_info/models/country_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://restcountries.com/v3.1")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/region/europe")
  Future<List<CountryModel>> getCountryInfo({
    @Query("fields")
    String fields = "name,capital,flags,region,languages,population",
  });
}
