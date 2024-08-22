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
        title: Text(country.name.common,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, 
        children: [
          _buildFlag(),
          const SizedBox(height: 16),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildFlag() {
    return Container(
      alignment: Alignment.center,
      child: Image.network(
        country.flags.png,
        width: 150, 
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDetails() {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          _buildListTile('Official Name', country.name.official),
          _buildListTile('Capital', country.capital.join(', ')),
          _buildListTile('Languages', country.languages!.keys.join(', ')),
          _buildListTile('Population', '${country.population}'),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
