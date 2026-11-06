import 'city.dart';

const cities = [
  City(
    'moscow',
    'Москва',
    'Россия',
    'Бульвары, музеи и набережные.',
  ),
  City(
    'kazan',
    'Казань',
    'Россия',
    'Кремль и прогулки у Казанки.',
  ),
  City(
    'almaty',
    'Алматы',
    'Казахстан',
    'Горы, парки и яблоневые сады.',
  ),
  City(
    'astana',
    'Астана',
    'Казахстан',
    'Новая архитектура на берегах Ишима.',
  ),
  City(
    'tbilisi',
    'Тбилиси',
    'Грузия',
    'Старый город и серные бани.',
  ),
  City(
    'batumi',
    'Батуми',
    'Грузия',
    'Море и длинный приморский бульвар.',
  ),
];

// #region queries
/// Страны в порядке первого появления в каталоге.
List<String> countriesOf(List<City> source) =>
    {for (final city in source) city.country}.toList();

/// Города одной страны; порядок каталога сохраняется.
List<City> citiesIn(List<City> source, String country) => [
  for (final city in source)
    if (city.country == country) city,
];
// #endregion
