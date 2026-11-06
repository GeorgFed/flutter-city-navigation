import 'package:city_catalog/city_catalog.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'tabs.dart';

// #region routes
/// Знает, как открыть экран и что он вернёт.
/// Не решает, что делать с результатом.
class CityRoutes {
  const CityRoutes();

  Future<City?> openDetails(
    BuildContext context,
    City city,
  ) => Navigator.of(context).push<City>(
    MaterialPageRoute<City>(
      builder: (routeContext) =>
          CityDetailsPage(city: city),
    ),
  );

  // #endregion

  Future<bool> confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Сбросить выбор?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<String?> pickCountry(
    BuildContext context,
    List<String> countries,
  ) => showModalBottomSheet<String>(
    context: context,
    builder: (sheetContext) => ListView(
      shrinkWrap: true,
      children: [
        for (final name in countries)
          ListTile(
            title: Text(name),
            onTap: () => Navigator.pop(sheetContext, name),
          ),
      ],
    ),
  );

  Future<void> openAbout(BuildContext context) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (routeContext) => const AboutPage(),
        ),
      );
}
