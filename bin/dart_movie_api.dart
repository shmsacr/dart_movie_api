import 'dart:convert';
import 'dart:io';

import 'package:dart_movie_api/src/constants/app_constants.dart';
import 'package:dart_movie_api/src/model/token_secret.dart';
import 'package:dart_movie_api/src/service/auth_service.dart';
import 'package:dart_movie_api/src/service/db_service.dart';
import 'package:dart_movie_api/src/service/password_service.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:dart_movie_api/src/service/token_service.dart';
import 'package:dart_movie_api/src/utils/config.dart';
import 'package:dart_movie_api/src/utils/email_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments) async {
  await initData();
  final app = Router();
  final port = Env.port;
  final dbInstance = Provider.of.fetch<DbService>();
  await dbInstance.openDb();

  app.get('/', (Request request) {
    return Response.ok(json.encode({'message': 'Hello World'}),
        headers: {'Content-Type': 'application/json'});
  });
  app.mount(
      '/auth',
      AuthService(
              store: Provider.of
                  .fetch<DbService>()
                  .getStore(AppConstants.userCollection),
              secret: "123456")
          .router);
  await serve(app, InternetAddress.anyIPv4, int.parse(port));
  print('Server running on port $port');
}

Future<void> initData() async {
  Provider.of
    ..register(DbService, () => DbService())
    ..register(RegexValidator,
        () => RegexValidator(regExpSource: AppConstants.emailRegex))
    ..register(PasswordService, () => PasswordService())
    ..register(
        TokenService,
        () => TokenService(
            store: Provider.of
                .fetch<DbService>()
                .getStore(AppConstants.tokenCollection)))
    ..register(TokenSecret, () => TokenSecret());
}
