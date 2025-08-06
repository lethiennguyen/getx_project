class ApiSingleResponse<T> {
  final bool success;
  final String message;
  final T data;

  ApiSingleResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiSingleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiSingleResponse(
      success: json['success'],
      message: json['message'],
      data: fromJsonT(json['data']),
    );
  }
}

class ApiListResponse<T> {
  final bool success;
  final String message;
  final List<T> data;

  ApiListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiListResponse.fromJson(
    Map<String, dynamic> j,
    T Function(dynamic) fromJsonT,
  ) => ApiListResponse(
    success: j['success'],
    message: j['message'],
    data: (j['data'] as List).map(fromJsonT).toList(),
  );
}
