import 'dart:ffi';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthService {
  final DbCollection store;
  final String secret;
  AuthService({required this.store, required this.secret});

  Handle get router {
    final app = Router();

    return app;
  }
}
