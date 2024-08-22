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
  late Future<List<CountryModel>> _countryFuture;

  @override
  void initState() {
    super.initState();
    _countryFuture = _fetchCountries();
  }

  Future<List<CountryModel>> _fetchCountries() async {
    final apiService =
        ApiService(Dio(BaseOptions(contentType: 'application/json')));
    return apiService.getCountryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSortDropdown(),
          Expanded(
            child: _buildCountryList(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue,
      title: const Text('European Countries',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }

  Widget _buildCountryList() {
    return FutureBuilder<List<CountryModel>>(
      future: _countryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final countryInfo = snapshot.data!;
          return _buildCountryListView(_sortCountries(countryInfo));
        } else {
          return const Center(child: Text('No data found'));
        }
      },
    );
  }

  Widget _buildCountryListView(List<CountryModel> countryInfo) {
    if (countryInfo.isEmpty) {
      return const Center(
        child: Text('No countries found'),
      );
    }
    return ListView.builder(
        itemCount: countryInfo.length,
        itemBuilder: (context, index) {
          final country = countryInfo[index];
          return ListTile(
            leading: Image.network(
              country.flags.png,
              width: 50,
              height: 30,
              fit: BoxFit.cover,
            ),
            title: Text(country.name.common),
            subtitle: Text(country.capital.join(', ')),
            onTap: () {
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

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      width: 300,
      child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.all(12),
          value: _sortBy,
          isExpanded: true,
          icon: const Icon(Icons.sort),
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
