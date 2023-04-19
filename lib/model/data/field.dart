import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class Field {
  /// Document ID from app server
  final String id;

  /// User-defined field display name
  final String name;

  /// List of IDs corresponding to gates in this field
  final List<String> gateIds;

  /// List of vertices defining the field polygon
  final List<LatLng> vertices;

  /// Get 'northeast coordinate' of field (helpful if field is a quadrilateral)
  /// Returns null if field does not have enought vertices.
  LatLng? get northeastCoord => _getDirectionalVertex(0);

  /// Get 'northwest coordinate' of field (helpful if field is a quadrilateral)
  /// Returns null if field does not have enought vertices.
  LatLng? get northwestCoord => _getDirectionalVertex(1);

  /// Get 'southeast coordinate' of field (helpful if field is a quadrilateral)
  /// Returns null if field does not have enought vertices.
  LatLng? get southeastCoord => _getDirectionalVertex(2);

  /// Get 'southwest coordinate' of field (helpful if field is a quadrilateral)
  /// Returns null if field does not have enought vertices.
  LatLng? get southwestCoord => _getDirectionalVertex(3);

  Field({
    required this.id,
    required this.name,
    this.vertices = const [],
    this.gateIds = const [],
  });

  /// Given a JSON response, such as that from the app server, returns a Field
  /// instance that is populated with the JSON data.
  ///
  /// A different factory implementation could be written for fields with an
  /// arbitrary number of vertices.
  factory Field.fromDirectionalJson(String id, Map<String, dynamic> json) {
    final List gates = json['gates'];

    final northeastVertex = _decodeLatLng(json['ne_point']);
    final northwestVertex = _decodeLatLng(json['nw_point']);
    final southeastVertex = _decodeLatLng(json['se_point']);
    final southwestVertex = _decodeLatLng(json['sw_point']);

    return Field(
      id: id,
      name: json['field_name'],
      gateIds: gates.cast<String>(),
      vertices: [
        northeastVertex,
        northwestVertex,
        southeastVertex,
        southwestVertex,
      ],
    );
  }

  /// Decode a LatLng represented as a String with components separated by a
  /// "|" (vertical bar), which is the format returned by the app server.
  static LatLng _decodeLatLng(String rawPoint) {
    final coordinate = rawPoint.split('|');
    return LatLng(
      double.parse(coordinate[0]),
      double.parse(coordinate[1]),
    );
  }

  /// Gets vertex by ID
  LatLng? _getDirectionalVertex(int index) {
    try {
      return vertices[index];
    } catch (_) {
      Logger().e(
        'No northeast vertex!\n'
        'Number of vertices is ${vertices.length}, tried to access index '
        '$index (max index is ${vertices.length - 1}).',
      );
      return null;
    }
  }
}
