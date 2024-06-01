class TokenResponse {
  String token, refreshToken;

  TokenResponse.fromJson(Map<String, dynamic> map)
      : token = map['access_token'],
        refreshToken = map['refresh_token'];
}
