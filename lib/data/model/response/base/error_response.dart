class ErrorResponse {
  ErrorResponse({required this.error});

  late final String error;

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}
