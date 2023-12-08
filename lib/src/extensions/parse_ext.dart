import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../model/req_user.dart';

extension ParseEmailAndPassword on Request {
  Future<ReqUser> get parseData async =>
      ReqUser.fromJson(json.decode(await readAsString()) as UserType);
}
