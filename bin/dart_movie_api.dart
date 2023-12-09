import 'dart:convert';
import 'dart:io';

import 'package:dart_movie_api/src/service/db_service.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments) async {
  await initData();
  final app = Router();
  final port = 8080;
  final dbInstance = Provider.of.fetch<DbService>();
  await dbInstance.openDb();

  app.get('/', (Request request) {
    return Response.ok(json.encode({'message': 'Hello World'}),
        headers: {'Content-Type': 'application/json'});
  });

  await serve(app, InternetAddress.anyIPv4, port);
  print('Server running on port $port');
}

Future<void> initData() async {
  Provider.of.register(DbService, () => DbService());
}
