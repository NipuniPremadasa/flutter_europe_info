import 'package:flutter/material.dart';
import 'package:flutter_europe_info/models/country_model.dart';

class CountryDetailedView extends StatelessWidget {
  final CountryModel country;
  const CountryDetailedView({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on screen width
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout(context);
          } else if (constraints.maxWidth < 1200) {
            return _buildTabletLayout(context);
          } else {
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  // Builds the app bar with country name
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue,
      title: Text(country.name.common,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }

  // Mobile layout - Flag and details in a vertical column
  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildFlag(),
          const SizedBox(height: 16),
          _buildCountryDetailsCard(),
        ],
      ),
    );
  }

  // Tablet layout - Scrollable view with flag and details in a column
  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildFlag(),
            const SizedBox(height: 24),
            _buildCountryDetailsCard(),
          ],
        ),
      ),
    );
  }

// Desktop layout - Scrollable view with flag and details side by side
  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildFlag(),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 3,
              child: _buildCountryDetailsCard(),
            ),
          ],
        ),
      ),
    );
  }

// Builds the country flag image
  Widget _buildFlag() {
    return Container(
      alignment: Alignment.center,
      child: Image.network(
        country.flags.png,
        fit: BoxFit.fitWidth,
      ),
    );
  }

// Builds a card with country details
  Widget _buildCountryDetailsCard() {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          _buildCountryDetailItem('Official Name', country.name.official),
          _buildCountryDetailItem('Capital', country.capital.join(', ')),
          _buildCountryDetailItem(
              'Languages', country.languages!.keys.join(', ')),
          _buildCountryDetailItem('Population', '${country.population}'),
        ],
      ),
    );
  }

// Builds a single country detail item with title and content
  Widget _buildCountryDetailItem(String title, String content) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(content),
    );
  }
}
