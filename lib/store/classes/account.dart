import 'package:jwt_decode/jwt_decode.dart';

import '../mutations/account_mutations.dart';
import '../../constants.dart' as constants;

class Account {
  String username = "";
  String email = "";
  String refreshToken = "";
  String accessToken = "";
  bool isStaff = false;
  int userId = -1;

  bool isConnected() {
    return userId != -1;
  }

  Map<String, String> getHeaders() {
    Map<String, String> newMap = {...constants.headersAnswer};
    newMap.putIfAbsent('Authorization', () => 'Bearer ' + accessToken);
    return newMap;
  }

  setUsername(String username) {
    this.username = username;
  }

  setEmail(String email) {
    this.email = email;
  }

  setRefreshToken(String token) {
    refreshToken = token;
  }

  setAccessToken(String token) {
    accessToken = token;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    DateTime? date = Jwt.getExpiryDate(token);
    if (date != null) {
      DateTime now = DateTime.now();
      final diff = date.difference(now) - const Duration(seconds: 250);
      Future.delayed(diff, () {
        ApiRefreshToken();
      });
    }

    username = payload['username'];
    email = payload['email'];
    isStaff = payload['is_staff'];
    userId = payload['user_id'];
  }
}
