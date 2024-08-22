import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_europe_info/models/country_model.dart';
import 'package:flutter_europe_info/pages/country_detailed_view.dart';
import 'package:flutter_europe_info/service/api_service.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  String _sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Flutter Europe Info'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _sortDropdown(),
          Expanded(
            child: _body(),
          ),
        ],

      ),
    );
  }

  FutureBuilder _body() {
    final apiService =
        ApiService(Dio(BaseOptions(contentType: 'application/json')));
    return FutureBuilder(
        future: apiService.getCountryInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              final List<CountryModel> countryInfo = snapshot.data;
              return _country(_sortCountries(countryInfo));
            } else {
              return const Center(child: Text('No data found'));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
            onTap: () {
              // Implement navigation to a CountryDetailScreen for more details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CountryDetailedView(country: country),
                ),
              );
            },
          );
        });
  }

  Widget _sortDropdown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<String>(
          value: _sortBy,
          isExpanded: true,
          items: const [
            DropdownMenuItem<String>(
                value: 'name', child: Text('Sort by name')),
            DropdownMenuItem<String>(
                value: 'population', child: Text('Sort by population')),
            DropdownMenuItem<String>(
                value: 'capital', child: Text('Sort by capital')),
          ],
          onChanged: (String? newvalue) {
            if (newvalue != null) {
              setState(() {
                _sortBy = newvalue;
              });
            }
          }),
    );
  }

  List<CountryModel> _sortCountries(List<CountryModel> countries) {
    switch (_sortBy) {
      case 'name':
        countries.sort((a, b) => a.name.common.compareTo(b.name.common));
        break;
      case 'population':
        countries.sort((a, b) => b.population.compareTo(a.population));
        break;
      case 'capital':
        countries.sort((a, b) => a.capital.first.compareTo(b.capital.first));       
        break;
    }
    return countries;
  }
}
