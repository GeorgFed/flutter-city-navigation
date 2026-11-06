import 'package:city_catalog/city_catalog.dart';
import 'package:test/test.dart';

void main() {
  test('Страны без повторов в порядке каталога', () {
    expect(countriesOf(cities), [
      'Россия',
      'Казахстан',
      'Грузия',
    ]);
  });

  test('Города одной страны в порядке каталога', () {
    expect(
      citiesIn(cities, 'Грузия').map((city) => city.id),
      ['tbilisi', 'batumi'],
    );
    expect(citiesIn(cities, 'Армения'), isEmpty);
  });

  test('Ссылка на карту содержит город и страну', () {
    final url = cities[1].mapUrl;
    expect(url.host, 'www.openstreetmap.org');
    expect(url.queryParameters['query'], 'Казань, Россия');
  });
}
