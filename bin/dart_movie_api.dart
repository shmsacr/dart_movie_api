import 'dart:io';

import 'package:dart_movie_api/src/constants/app_constants.dart';
import 'package:dart_movie_api/src/extensions/http_ext.dart';
import 'package:dart_movie_api/src/middlewares/auth_middleware.dart';
import 'package:dart_movie_api/src/middlewares/cors_middleware.dart';
import 'package:dart_movie_api/src/model/token_secret.dart';
import 'package:dart_movie_api/src/service/auth_service.dart';
import 'package:dart_movie_api/src/service/db_service.dart';
import 'package:dart_movie_api/src/service/movie_service.dart';
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

  app.mount(
      '/auth',
      AuthService(
              store: dbInstance.getStore(AppConstants.userCollection),
              secret: Env.secret)
          .router);
  app.mount(
      '/movies',
      MovieService(store: dbInstance.getStore(AppConstants.movieCollection))
          .router);
  app.all('crouteName|.*>', (Request request) {
    final indexFile = File('public/main.html').readAsStringSync();
    return Response.ok(indexFile, headers: CustomHeader.html.getType);
  });
  final handler = Pipeline()
      .addMiddleware(corsMiddleware())
      .addMiddleware(authMiddleware())
      .addHandler(app);
  await serve(handler, InternetAddress.anyIPv4, int.parse(port));
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
