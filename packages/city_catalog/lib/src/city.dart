// #region model
class City {
  const City(
    this.id,
    this.name,
    this.country,
    this.description,
  );
  final String id;
  final String name;
  final String country;
  final String description;

  Uri get mapUrl => Uri.https(
    'www.openstreetmap.org',
    '/search',
    {'query': '$name, $country'},
  );
}

// #endregion
