import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_movie_api/src/extensions/http_ext.dart';
import 'package:dart_movie_api/src/model/token_secret.dart';
import 'package:dart_movie_api/src/service/token_service.dart';
import 'package:shelf/shelf.dart';

import '../service/provider.dart';

Middleware authMiddleware() {
  return (Handler innerHadler) {
    return (Request request) {
      try {
        final ts = Provider.of.fetch<TokenService>();
        final autheader = request.headers['Authorization'];
        final tsInst = Provider.of.fetch<TokenSecret>();
        String? token;
        JWT? jwt;
        if (autheader != null && autheader.startsWith('Bearer ')) {
          token = autheader.substring(7);
          jwt = ts.verifyJwt(token, tsInst.getSecret);
        }
        final updateRequest = request.change(context: {'authDetails': jwt});
        return innerHadler(updateRequest);
      } on JwtCustomException catch (err) {
        return Response.badRequest(
            body: json.encode({'error': err.error}),
            headers: CustomHeader.json.getType);
      }
    };
  };
}
