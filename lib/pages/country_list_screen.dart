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
  String _sortBy = 'name'; // Default sorting option
  late Future<List<CountryModel>> _countryFuture;

  @override
  void initState() {
    super.initState();
    _countryFuture = _fetchCountries();
  }

// Fetch countries from the API
  Future<List<CountryModel>> _fetchCountries() async {
    final apiService =
        ApiService(Dio(BaseOptions(contentType: 'application/json')));
    return apiService.getCountryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on screen width
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return _buildMobileLayout();
          } else if (constraints.maxWidth < 1200) {
            // Tablet layout
            return _buildTabletLayout();
          } else {
            // Desktop layout
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  // Build the app bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue,
      title: const Text('European Countries',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }

// Mobile layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildSortDropdown(),
        Expanded(
          child: _buildCountryList(),
        ),
      ],
    );
  }

// Mobile layout
  Widget _buildTabletLayout() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 300, // Decreased width of the dropdown
            child: _buildSortDropdown(),
          ),
        ),
        Expanded(
          flex: 3,
          child: _buildCountryList(),
        ),
      ],
    );
  }

  // Desktop layout
  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 300, // Decreased width of the dropdown
            child: _buildSortDropdown(),
          ),
        ),
        Expanded(
          flex: 4,
          child: _buildCountryList(),
        ),
      ],
    );
  }

  // Build the country list using FutureBuilder
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

// Build the GridView for country list
  Widget _buildCountryListView(List<CountryModel> countryInfo) {
    if (countryInfo.isEmpty) {
      return const Center(
        child: Text('No countries found'),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
            childAspectRatio: 3,
          ),
          itemCount: countryInfo.length,
          itemBuilder: (context, index) {
            final country = countryInfo[index];
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CountryDetailedView(country: country),
                    ),
                  );
                },
                child: ListTile(
                  leading: Image.network(
                    country.flags.png,
                    width: 100,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(country.name.common,
                      overflow: TextOverflow.ellipsis),
                  subtitle: Text(country.capital.join(', '),
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            );
          },
        );
      },
    );
  }

// Determine the number of columns based on screen width
  int _getCrossAxisCount(double width) {
    if (width < 600) return 1;
    if (width < 1200) return 2;
    return 3;
  }

// Build the sorting dropdown
  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(12),
        value: _sortBy,
        isExpanded: true,
        icon: const Icon(Icons.sort),
        items: const [
          DropdownMenuItem<String>(value: 'name', child: Text('Sort by name')),
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
        },
      ),
    );
  }

// Sort countries based on selected criteria
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
