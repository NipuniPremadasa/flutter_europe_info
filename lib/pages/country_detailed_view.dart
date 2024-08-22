import 'package:flutter/material.dart';
import 'package:flutter_europe_info/models/country_model.dart';

class CountryDetailedView extends StatelessWidget {
  final CountryModel country;
  const CountryDetailedView({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(country.name.common),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.network(
            country.flags.png,
            width: 100,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text('Official Name: ${country.name.official}'),
          Text('Capital: ${country.capital.join(', ')}'),
          Text('Languages: ${country.languages!.keys.join(', ')}'),
          Text('Population: ${country.population}'),
        ],
      ),
    );
  }
}
