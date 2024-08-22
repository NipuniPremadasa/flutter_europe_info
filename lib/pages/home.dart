import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_europe_info/models/country_model.dart';
import 'package:flutter_europe_info/service/api_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text('Flutter Europe Info'),
          centerTitle: true,
        ),
        body: _body());
  }

  FutureBuilder _body() {
    final apiService =
        ApiService(Dio(BaseOptions(contentType: 'application/json')));
    return FutureBuilder(
        future: apiService.getCountryInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<CountryModel> countryInfo = snapshot.data;
            return _country(countryInfo);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _country(List<CountryModel> countryInfo) {
    return ListView.builder(
        itemCount: countryInfo.length,
        itemBuilder: (context, index) {
          final CountryModel country = countryInfo[index];
          return ListTile(
            leading: Image.network(
              country.flags.png, // Display the flag using the PNG URL
              width: 50, // Set a fixed width for the flag image
              height: 30, // Set a fixed height for the flag image
              fit: BoxFit.cover, // Ensure the flag image fits the box
            ),
            title: Text(country.name.common),
            subtitle: Text(country.capital.join(', ')),
            // trailing: Text(country.population.toString()),
          );
        });
  }
}
