import 'dart:math';

class CompassService {
  CompassService();

  double calculateBearingBetweenTwoLocations({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final l = lng2 - lng1;

    final x = cos(lat2 * pi / 180) * sin(l * pi / 180);

    final y = cos(lat1 * pi / 180) *
            sin(lat2 * pi / 180) -
        sin(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            cos(l * pi / 180);

    final bearingRad = atan2(x, y);
    final bearing = bearingRad * (180 / pi);

    return bearing;
  }
}
