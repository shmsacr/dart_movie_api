import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dart_movie_api/src/extensions/parse_ext.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../extensions/http_ext.dart';

class AuthService {
  final DbCollection store;
  final String secret;
  AuthService({required this.store, required this.secret});

  Handle get router {
    final app = Router();

    /// Register POST Request
    app.post("/register", (Request request) async {
      final user = await request.parseData;
      if (user.email!.isEmpty || user.password!.isEmpty) {
        return Response(HttpStatus.badRequest,
            body: jsonEncode({"error: Please provider your email/password"}),
            headers: CustomHeader.json.getType);
      }
    });

    return app;
  }
}
