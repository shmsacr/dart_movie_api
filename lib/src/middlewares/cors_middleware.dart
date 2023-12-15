import 'package:shelf/shelf.dart';

Middleware corsMiddleware() {
  return createMiddleware(requestHandler: (Request request) {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: corsHeaders);
    }
    return null;
  }, responseHandler: (Response response) {
    return response.change(headers: corsHeaders);
  });
}

const corsHeaders = {
  'Acces-Control-Allow-Origin': '*',
  'Access-Control-Allow-Method': 'GET,POST,PUT,DELETE',
  'Acces-Control-Allow-Header': 'Origin,Content-type'
};
