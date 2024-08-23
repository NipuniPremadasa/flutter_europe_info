import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_europe_info/service/api_service.dart';
import 'package:flutter_europe_info/models/country_model.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiService apiService;

  // Set up the Dio and ApiService instances before each test
  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://restcountries.com/v3.1'));
    dioAdapter = DioAdapter(dio: dio);
    apiService = ApiService(dio);
  });

  group('ApiService Tests', () {
    test('getCountryInfo returns list of CountryModel', () async {
      // Arrange - Set up mock response data
      final responseData = [
        {
          "flags": {
            "png": "https://flagcdn.com/w320/de.png",
            "svg": "https://flagcdn.com/de.svg",
            "alt":
                "The flag of Germany is composed of three equal horizontal bands of black, red and gold."
          },
          "name": {
            "common": "Germany",
            "official": "Federal Republic of Germany",
            "nativeName": {
              "deu": {
                "official": "Bundesrepublik Deutschland",
                "common": "Deutschland"
              }
            }
          },
          "capital": ["Berlin"],
          "region": "Europe",
          "languages": {"deu": "German"},
          "population": 83240525
        }
      ];
      // Configure the DioAdapter to return the mock data for the given endpoint
      dioAdapter.onGet(
        '/region/europe',
        (server) => server.reply(200, responseData),
        queryParameters: {
          'fields': 'name,capital,flags,region,languages,population'
        },
      );

      // Act - Call the getCountryInfo method
      final result = await apiService.getCountryInfo();

      // Assert - Verify the results
      expect(result, isA<List<CountryModel>>());
      expect(result.length, 1);
      expect(result[0].name.common, 'Germany');
      expect(result[0].capital[0], 'Berlin');
      expect(result[0].region, Region.EUROPE);
    });
  });
}
