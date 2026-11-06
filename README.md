# Города: навигация и зависимости

Код к лекциям 7 ноября 2026 «Навигация во Flutter» и «Зависимости во Flutter». Это готовый демонстрационный пример, не задание. Данные локальные: шесть городов, три страны.

Презентации: [навигация](https://georgfed.github.io/hse-flutter-course/decks/navigation.html) · [зависимости](https://georgfed.github.io/hse-flutter-course/decks/dependencies.html). Фрагменты кода на слайдах взяты из этого репозитория — ищите их по меткам `// #region`.

Проверенное окружение: Flutter 3.35.7 / Dart 3.9.2, url_launcher 6.3.2. `pubspec.lock` сохраняется для воспроизводимой установки приложения.

```sh
flutter pub get
flutter run -d chrome -t lib/main.dart   # список, детали, диалог, SnackBar, карта
flutter run -d chrome -t lib/tabs.dart   # таб-бар, нижний лист, боковое меню
```

- `lib/main.dart`: список городов, детали с возвратом результата, диалог сброса, SnackBar, кнопка «Открыть на карте» через url_launcher.
- `lib/tabs.dart`: оболочка с NavigationBar + IndexedStack, вкладка «Страны» с нижним листом, Drawer с разделами и «О приложении».
- `lib/routes.dart`: `CityRoutes` — все переходы в одном классе; экраны получают его через конструктор.
- `packages/city_catalog`: свой пакет на чистом Dart — модель City, данные, выборки. Подключён по path.
- `test/cities_test.dart`: навигация, отмена, SnackBar, подмена `CityRoutes`, подмена платформы url_launcher.
- `test/tabs_test.dart`: вкладки, нижний лист, шторка.

Сценарий: откройте Казань → выберите → откройте Москву → Back. Казань остаётся выбранной. Отмена сброса сохраняет выбор, подтверждение очищает его и показывает «Выбор сброшен». Во вкладках выбор города и страны переживает переключение; детали открываются поверх панели.

```sh
flutter analyze --no-pub
flutter test --no-pub                       # 14 проверок
(cd packages/city_catalog && dart test)     # 3 проверки пакета
flutter build web --no-pub -t lib/main.dart
flutter build web --no-pub -t lib/tabs.dart
```

Код отформатирован с `dart format --line-length 60`, чтобы помещаться на слайды. Кнопка карты требует сети и браузера; остальное работает офлайн после установки пакетов.
