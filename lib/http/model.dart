class ApiResponse {
  bool error;
  String message;
  List<Data> data;

  ApiResponse({required this.error, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: json['error'],
      message: json['message'],
      data: List<Data>.from(json['data'].map((item) => Data.fromJson(item))),
    );
  }
}

class Data {
  String id;
  List<String> field;
  Coordinates start;
  Coordinates end;

  Data({required this.id, required this.field, required this.start, required this.end});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      field: List<String>.from(json['field']),
      start: Coordinates.fromJson(json['start']),
      end: Coordinates.fromJson(json['end']),
    );
  }
}

class Coordinates {
  int x;
  int y;

  Coordinates( this.x, this.y);

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
       json['x'],
       json['y'],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Coordinates && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
