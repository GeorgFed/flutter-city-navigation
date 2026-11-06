import 'package:city_navigation/main.dart';
import 'package:city_navigation/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> launch(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: cityTheme, home: const TabsPage()),
    );
  }

  Future<void> openTab(
    WidgetTester tester,
    String label,
  ) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Детали открываются поверх панели вкладок', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.text('Казань'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.text('Выбрать этот город'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Выбран: Казань'), findsOneWidget);
  });

  testWidgets('Вкладки сохраняют State друг друга', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.text('Казань'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Выбрать этот город'));
    await tester.pumpAndSettle();
    await openTab(tester, 'Страны');
    await tester.tap(find.text('Выбрать страну'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Грузия'));
    await tester.pumpAndSettle();
    expect(find.text('Страна: Грузия'), findsOneWidget);
    expect(find.text('Батуми'), findsOneWidget);
    await openTab(tester, 'Города');
    expect(find.text('Выбран: Казань'), findsOneWidget);
    await openTab(tester, 'Страны');
    expect(find.text('Страна: Грузия'), findsOneWidget);
  });

  testWidgets(
    'Закрытие листа без выбора сохраняет страну',
    (tester) async {
      await launch(tester);
      await openTab(tester, 'Страны');
      await tester.tap(find.text('Выбрать страну'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Казахстан'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Выбрать страну'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(
        find.text('Страна: Казахстан'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Шторка переключает раздел и закрывается', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(
      find.byTooltip('Open navigation menu'),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('Страны'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Страна не выбрана'), findsOneWidget);
    final bar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(bar.selectedIndex, 1);
  });

  testWidgets('Пункт шторки открывает экран поверх', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(
      find.byTooltip('Open navigation menu'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('О приложении'));
    await tester.pumpAndSettle();
    expect(find.byType(AboutPage), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
  });
}
