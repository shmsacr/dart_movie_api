import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

Middleware checkLogingUser(DbCollection store) {
  return (Handler innerHandler) {
    return (Request request) {
      final query = request.requestedUri.path.substring(6).toLowerCase();
      if (query == 'me') {
        if (request.context['authDetails'] == null) {
          return Response.forbidden('Not authorized to perform this action');
        }
      }
      return innerHandler(request);
    };
  };
}
