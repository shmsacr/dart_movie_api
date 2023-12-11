import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TokenService {
  final DbCollection store;
  TokenService({required this.store});
  String generateJwt(String subject, String issuer, String secret,
      [String? jwtId, Duration expiry = const Duration(minutes: 1)]) {
    final jwt = JWT(
      {'iat': DateTime.now().millisecondsSinceEpoch},
      issuer: issuer,
      jwtId: jwtId,
      subject: subject,
    );
    return jwt.sign(SecretKey(secret), expiresIn: expiry);
  }

  JWT verifyJwt(String token, String secret) {
    try {
      final jwt = JWT.verify(token, SecretKey(secret));
      return jwt;
    } on JWTExpiredException {
      throw Exception('JWT expired...');
    } on JWTInvalidException {
      throw Exception("Invalid token...");
    }
  }
}
