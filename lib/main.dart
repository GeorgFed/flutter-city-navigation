import 'package:city_catalog/city_catalog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'routes.dart';

void main() => runApp(const CitiesApp());

final cityTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xff5d7da8),
  ),
  scaffoldBackgroundColor: const Color(0xfff6f8fa),
  useMaterial3: true,
);

class CitiesApp extends StatelessWidget {
  const CitiesApp({
    super.key,
    this.routes = const CityRoutes(),
  });
  final CityRoutes routes;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: cityTheme,
    home: Scaffold(
      appBar: AppBar(title: const Text('Города')),
      body: CitiesView(routes: routes),
    ),
  );
}

class CitiesView extends StatefulWidget {
  const CitiesView({
    super.key,
    this.routes = const CityRoutes(),
  });
  final CityRoutes routes;

  @override
  State<CitiesView> createState() => _CitiesViewState();
}

class _CitiesViewState extends State<CitiesView> {
  City? selected;

  // #region open-city
  Future<void> openCity(City city) async {
    final result = await widget.routes.openDetails(
      context,
      city,
    );
    if (!mounted || result == null) return;
    setState(() => selected = result);
  }
  // #endregion

  // #region reset
  Future<void> resetSelection() async {
    final confirmed = await widget.routes.confirmReset(
      context,
    );
    if (!mounted || !confirmed) return;
    setState(() => selected = null);
    // #region snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Выбор сброшен')),
    );
    // #endregion
  }
  // #endregion

  // #region tile
  Widget cityTile(City city) => ListTile(
    leading: const Icon(Icons.location_city),
    title: Text(city.name),
    subtitle: Text(city.country),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => openCity(city),
  );
  // #endregion

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          selected == null
              ? 'Город не выбран'
              : 'Выбран: ${selected!.name}',
          key: const Key('selection'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      Expanded(
        child: ListView(
          children: cities.map(cityTile).toList(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: OutlinedButton(
          onPressed: selected == null
              ? null
              : resetSelection,
          child: const Text('Сбросить выбор'),
        ),
      ),
    ],
  );
}

// #region details
class CityDetailsPage extends StatelessWidget {
  const CityDetailsPage({super.key, required this.city});
  final City city;

  // #region open-map
  Future<void> openMap(BuildContext context) async {
    final opened = await launchUrl(city.mapUrl);
    if (opened || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Не удалось открыть карту'),
      ),
    );
  }
  // #endregion

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(city.name)),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            city.country,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(city.description),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => openMap(context),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Открыть на карте'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            // #region select
            onPressed: () =>
                Navigator.pop<City>(context, city),
            child: const Text('Выбрать этот город'),
            // #endregion
          ),
        ],
      ),
    ),
  );
}

// #endregion
