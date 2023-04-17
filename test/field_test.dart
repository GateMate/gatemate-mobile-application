import 'dart:convert';

import 'package:gatemate_mobile/model/data/field.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Factory constructor given typical input should correctly populate member variables',
    () {
      const fieldJson =
          '{"field_name":"test_field","gates":["GQ9vhGkNjGgpx5hDr7T8",'
          '"ex2UkYGSgkXDBN7TcKdO","FWvKekFxCJINB94WoPBz","wEKwgDUkusTKiRZHNxzy",'
          '"d3NHVV8VmcmVeK1fmYQn"],"ne_point":"36.1|-94.1","nw_point":"36.1|-94.2",'
          '"se_point":"36.0|-94.1","sw_point":"36.0|-94.2","user_id":3}';

      final field = Field.fromDirectionalJson(jsonDecode(fieldJson));

      expect(field.name, equals('test_field'));
      expect(field.gateIds[1], equals('ex2UkYGSgkXDBN7TcKdO'));
      expect(field.vertices[2].longitude, equals(-94.1));
      expect(field.northeastCoord?.latitude, equals(36.1));
      expect(field.vertices.length, equals(4));
    },
  );

  test(
    'Three-vertex field should return null southwest vertex, but others properly',
    () {
      final field = Field(
        name: 'test',
        gateIds: ['first', 'second'],
        vertices: [LatLng(3.0, 4.0), LatLng(1.0, 2.0), LatLng(5.0, 6.0)],
      );

      expect(field.southwestCoord, equals(null));
      expect(field.vertices[2].longitude, equals(6.0));
      expect(field.northwestCoord?.latitude, equals(1.0));
    },
  );
}
