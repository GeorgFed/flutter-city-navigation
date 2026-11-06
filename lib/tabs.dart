import 'package:city_catalog/city_catalog.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'routes.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: cityTheme,
    home: const TabsPage(),
  ),
);

// #region sections
const sections = ['Города', 'Страны'];
// #endregion

class TabsPage extends StatefulWidget {
  const TabsPage({
    super.key,
    this.routes = const CityRoutes(),
  });
  final CityRoutes routes;

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int tab = 0;

  // #region select-section
  void selectSection(int index) =>
      setState(() => tab = index);
  // #endregion

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(sections[tab])),
    // #region drawer
    drawer: Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Каталог городов'),
          ),
          for (final (index, label) in sections.indexed)
            ListTile(
              title: Text(label),
              selected: index == tab,
              onTap: () {
                Navigator.pop(context);
                selectSection(index);
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            onTap: () {
              Navigator.pop(context);
              widget.routes.openAbout(context);
            },
          ),
        ],
      ),
    ),
    // #endregion
    // #region body
    body: IndexedStack(
      index: tab,
      children: [
        CitiesView(routes: widget.routes),
        CountriesView(routes: widget.routes),
      ],
    ),
    // #endregion
    // #region navigation-bar
    bottomNavigationBar: NavigationBar(
      selectedIndex: tab,
      onDestinationSelected: selectSection,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.location_city),
          label: 'Города',
        ),
        NavigationDestination(
          icon: Icon(Icons.public),
          label: 'Страны',
        ),
      ],
    ),
    // #endregion
  );
}

class CountriesView extends StatefulWidget {
  const CountriesView({
    super.key,
    this.routes = const CityRoutes(),
  });
  final CityRoutes routes;

  @override
  State<CountriesView> createState() =>
      _CountriesViewState();
}

class _CountriesViewState extends State<CountriesView> {
  String? country;

  // #region sheet
  Future<void> pickCountry() async {
    final result = await widget.routes.pickCountry(
      context,
      countriesOf(cities),
    );
    if (!mounted || result == null) return;
    setState(() => country = result);
  }
  // #endregion

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          country == null
              ? 'Страна не выбрана'
              : 'Страна: $country',
          key: const Key('country'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        if (country != null)
          for (final city in citiesIn(cities, country!))
            Text(city.name),
        const Spacer(),
        FilledButton(
          onPressed: pickCountry,
          child: const Text('Выбрать страну'),
        ),
      ],
    ),
  );
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('О приложении')),
    body: const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Учебный каталог: шесть городов, три страны. '
        'Данные локальные.',
      ),
    ),
  );
}
