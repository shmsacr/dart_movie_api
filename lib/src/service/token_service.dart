import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_movie_api/src/model/token_pair.dart';
import 'package:dart_movie_api/src/model/token_secret.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TokenService {
  final DbCollection store;
  TokenService({required this.store});
  String generateJwt(String subject, String issuer, String secret,
      {String? jwtId, Duration expiry = const Duration(minutes: 1)}) {
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
      throw JwtCustomException(error: 'JWT expired...');
    } on JWTInvalidException {
      throw JwtCustomException(error: "Invalid token...");
    } on JWTUndefinedException {
      throw JwtCustomException(error: 'Invalid length');
    }
  }

  Future<Map<String, dynamic>?> getToken(String tokenId) async {
    return await store.findOne(where.eq('tokenId', tokenId));
  }

  Future<TokenPair> createTokenPair(String userId) async {
    final ts = Provider.of.fetch<TokenSecret>();

    final String tokenId = Uuid().v4();
    final aToken =
        generateJwt(userId, 'http://localhost', ts.getSecret, jwtId: tokenId);
    const refresTokenExpiry = Duration(minutes: 5);
    final rToken = generateJwt(userId, 'http://localhost', ts.getSecret,
        expiry: refresTokenExpiry, jwtId: tokenId);
    await addTokenPair(tokenId, aToken, rToken);
    return TokenPair(aToken: aToken, rToken: rToken);
  }

  Future<void> addTokenPair(
      String tokenId, String aToken, String rToken) async {
    await store
        .insertOne({'tokenId': tokenId, 'aToken': aToken, 'rToken': rToken});
  }

  Future<dynamic> removeToken(String tokenId) async {
    return await store.deleteOne({'tokenId': tokenId});
  }
}

class JwtCustomException implements Exception {
  final String error;
  const JwtCustomException({required this.error});
}
