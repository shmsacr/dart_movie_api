import 'dart:convert';
import 'dart:io';

import 'package:dart_movie_api/src/extensions/parse_ext.dart';
import 'package:dart_movie_api/src/service/password_service.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:dart_movie_api/src/utils/email_validator.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../extensions/http_ext.dart';

class AuthService {
  final DbCollection store;
  final String secret;
  AuthService({required this.store, required this.secret});

  Handler get router {
    final app = Router();
    final rx = Provider.of.fetch<RegexValidator>();
    final ps = Provider.of.fetch<PasswordService>();

    /// Register POST Request
    app.post("/register", (Request request) async {
      final user = await request.parseData;
      if (user.email!.isEmpty || user.password!.isEmpty) {
        return Response(HttpStatus.badRequest,
            body: jsonEncode({"error: Please provider your email/password"}),
            headers: CustomHeader.json.getType);
      }
      final addedUser = await store.findOne(where.eq("email", user.email));
      if (addedUser != null) {
        return Response.badRequest(
            body: json.encode({"error": "User already exists"}),
            headers: CustomHeader.json.getType);
      }
      if (!rx.isValid(user.email!)) {
        return Response(HttpStatus.badRequest,
            body:
                json.encode({"error": "Please provide correct email address"}),
            headers: CustomHeader.json.getType);
      }
      final salt = ps.generateSalt();
      final hashedPassword = ps.hashPassword(user.password!, salt);
      await store.insertOne(
          {"email": user.email, 'password': hashedPassword, 'salt': salt});
      return Response.ok(
          json.encode({'message': 'User saved. Please redirec to login'}),
          headers: CustomHeader.json.getType);
    });

    return app;
  }
}
