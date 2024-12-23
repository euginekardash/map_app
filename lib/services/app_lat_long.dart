class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });
}

class MinskLocation extends AppLatLong {
  const MinskLocation({
    super.lat = 53.893009,
    super.long = 27.567444,
  });
}