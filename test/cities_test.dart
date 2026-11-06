import 'package:city_catalog/city_catalog.dart';
import 'package:city_navigation/main.dart';
import 'package:city_navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

// #region fake-routes
/// Подмена переходов: проверяем решение State
/// без настоящего экрана деталей.
class PickKazanRoutes extends CityRoutes {
  const PickKazanRoutes();

  @override
  Future<City?> openDetails(
    BuildContext context,
    City city,
  ) async => cities[1];
}
// #endregion

// #region fake-launcher
class FakeLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  FakeLauncher(this.result);
  final bool result;
  final opened = <String>[];

  @override
  Future<bool> launchUrl(
    String url,
    LaunchOptions options,
  ) async {
    opened.add(url);
    return result;
  }
}
// #endregion

void main() {
  Future<void> openKazan(WidgetTester tester) async {
    await tester.tap(find.text('Казань'));
    await tester.pumpAndSettle();
  }

  Future<void> selectKazan(WidgetTester tester) async {
    await openKazan(tester);
    await tester.tap(find.text('Выбрать этот город'));
    await tester.pumpAndSettle();
  }

  testWidgets('Детали показывают выбранный город', (
    tester,
  ) async {
    await tester.pumpWidget(const CitiesApp());
    await openKazan(tester);
    expect(
      find.text('Кремль и прогулки у Казанки.'),
      findsOneWidget,
    );
    expect(find.text('Выбрать этот город'), findsOneWidget);
  });

  testWidgets('Выбор возвращается на список', (
    tester,
  ) async {
    await tester.pumpWidget(const CitiesApp());
    await selectKazan(tester);
    expect(find.text('Выбран: Казань'), findsOneWidget);
  });

  testWidgets(
    'Back без выбора сохраняет прежний результат',
    (tester) async {
      await tester.pumpWidget(const CitiesApp());
      await selectKazan(tester);
      await tester.tap(find.text('Москва'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Выбран: Казань'), findsOneWidget);
    },
  );

  for (final confirm in [false, true]) {
    testWidgets('Диалог сброса: $confirm', (tester) async {
      await tester.pumpWidget(const CitiesApp());
      await selectKazan(tester);
      await tester.tap(find.text('Сбросить выбор'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(confirm ? 'Сбросить' : 'Отмена'),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          confirm ? 'Город не выбран' : 'Выбран: Казань',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Выбор сброшен'),
        confirm ? findsOneWidget : findsNothing,
      );
    });
  }

  testWidgets(
    'Закрытие диалога через Back не сбрасывает выбор',
    (tester) async {
      await tester.pumpWidget(const CitiesApp());
      await selectKazan(tester);
      await tester.tap(find.text('Сбросить выбор'));
      await tester.pumpAndSettle();
      Navigator.pop(
        tester.element(find.byType(AlertDialog)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Выбран: Казань'), findsOneWidget);
    },
  );

  // #region fake-routes-test
  testWidgets('Решение State проверяется без перехода', (
    tester,
  ) async {
    await tester.pumpWidget(
      const CitiesApp(routes: PickKazanRoutes()),
    );
    await tester.tap(find.text('Москва'));
    await tester.pump();
    expect(find.byType(CityDetailsPage), findsNothing);
    expect(find.text('Выбран: Казань'), findsOneWidget);
  });
  // #endregion

  for (final opened in [true, false]) {
    testWidgets('Карта через плагин: открыта = $opened', (
      tester,
    ) async {
      final launcher = FakeLauncher(opened);
      UrlLauncherPlatform.instance = launcher;
      await tester.pumpWidget(const CitiesApp());
      await openKazan(tester);
      await tester.tap(find.text('Открыть на карте'));
      await tester.pumpAndSettle();
      expect(
        launcher.opened.single,
        contains('openstreetmap'),
      );
      expect(
        find.text('Не удалось открыть карту'),
        opened ? findsNothing : findsOneWidget,
      );
    });
  }
}
