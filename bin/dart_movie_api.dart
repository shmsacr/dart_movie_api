import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments) async {
  final app = Router();
  final port = 8080;
  app.get('/', (Request request) {
    return Response.ok(json.encode({'message': 'Hello World'}),
        headers: {'Content-Type': 'application/json'});
  });
  await serve(app, InternetAddress.anyIPv4, port);
  print('Server running on port $port');
}
