import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import '../main.dart';
import '../../lib/sqljocky/sqljocky.dart';
import '../../lib/password/password.dart';

Future<FutureOr> Request_authUser(Context context) async {

    Cookie cookie = new Cookie();
    cookie.httpOnly = true;

    Map reply = new Map();
    final String username = context.pathParams.get('user', null).trim();
    final String password = context.query.get('password', null);

    if (username == null){
        reply['error'] = 'Missing required parameter user!';
        return reply;
    }

    if (password == null){
        reply['error'] = 'Missing required parameter password!';
        return reply;
    }

    //Check if user is already registered
    Query query = await pool.prepare('SELECT password FROM users WHERE username = ?');
    Results res = await query.execute([username]);
    var result = await res.toList();
    if (result.length == 0 || !Password.verify(password, result[0][0])){
        reply['error'] = 'Authentication failed!';
        return reply;
    }

    reply['error'] = null;
    reply['message'] = 'Authentication successfull';
    print(context.bodyAsText());

    return reply;
}