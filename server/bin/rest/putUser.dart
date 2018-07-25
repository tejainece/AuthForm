import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import '../main.dart';
import '../../lib/sqljocky/sqljocky.dart';
import '../../lib/password/password.dart';

Future<FutureOr> Request_PutUser(Context context) async {
    Map reply = new Map();
    final String username = context.pathParams.get('user', null).trim();
    final String password = context.query.get('password', null);

    //Check if username is valid
    if (username.length < 3){
        reply['error'] = 'Invalid username, must be greater than 2!';
        return reply;
    }
    if (username.length > 15){
        reply['error'] = 'Invalid username, must be lower than 15!';
        return reply;
    }

    //Check if password is valid
    if (password == null){
        reply['error'] = 'Missing required password parameter!';
        return reply;
    }
    if (password.length < 4){
        reply['error'] = 'Invalid password must be greated than 4!';
        return reply;
    }

    //Check if user is already registered
    Query query = await pool.prepare('SELECT username FROM users WHERE username = ?');
    Results res = await query.execute([username]);
    var result = await res.toList();
    if (await res.length == 1){
        reply['error'] = 'Username already exists!';
        return reply;
    }

    //Check if we have already 2 account with this ip
    String ip = context.req.headers['x-forwarded-for'][0];
    query = await pool.prepare('SELECT username FROM users WHERE ip = ?');
    res = await query.execute([ip]);
    if (await res.length == 2){
        reply['error'] = 'Max registrations with your IP($ip) excedeed (2)!';
        return reply;
    }

    //Insert new user
    query = await pool.prepare('INSERT INTO users (username, password, ip) VALUES (?, ?, ?);');
    res = await query.execute([username, Password.hash(password, algorithm), ip]);

    reply['error'] = null;
    reply['message'] = 'User added successfully';
    return reply;
}