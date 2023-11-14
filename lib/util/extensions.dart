import 'package:syncfusion_flutter_maps/maps.dart';

extension MyMapPolygon on MapPolygon {
  bool _rayCastIntersect(MapLatLng point, MapLatLng vertA, MapLatLng vertB) {
    final aY = vertA.latitude;
    final bY = vertB.latitude;
    final aX = vertA.longitude;
    final bX = vertB.longitude;
    final pY = point.latitude;
    final pX = point.longitude;
    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false;
    }
    final m = (aY - bY) / (aX - bX);
    final bee = (-aX) * m + aY;
    final x = (pY - bee) / m;
    return x > pX;
  }

  bool contains(MapLatLng point) {
    int intersectCount = 0;
    for (int i = 0; i < points.length - 1; i++) {
      if (_rayCastIntersect(point, points[i], points[i + 1])) {
        intersectCount++;
      }
    }
    return intersectCount.isOdd;
  }
}
