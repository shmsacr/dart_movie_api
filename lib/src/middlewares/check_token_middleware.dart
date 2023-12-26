import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:shelf/shelf.dart';

import '../extensions/http_ext.dart';
import '../service/token_service.dart';

Middleware checkToken() {
  return createMiddleware(requestHandler: (Request request) async {
    final auth = request.context['authDetails'];
    final currToken =
        await Provider.of.fetch<TokenService>().getToken((auth as JWT).jwtId!);
    if (currToken == null) {
      return Response.forbidden(
          json.encode({'error': 'Not authorized to perform this action'}),
          headers: CustomHeader.json.getType);
    }
    return null;
  });
}
