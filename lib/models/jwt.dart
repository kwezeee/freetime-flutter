class JwtResponse {
  final String accessToken;
  final String refreshToken;

  const JwtResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) => JwtResponse(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
  );

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}
