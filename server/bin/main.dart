import 'dart:io';
import '../lib/sqljocky/sqljocky.dart';
import '../lib/password/password.dart';
import 'package:jaguar/jaguar.dart';

import 'rest/putUser.dart';
import 'rest/authUser.dart';


ConnectionPool pool;
final algorithm = new PBKDF2();

void main() async {

    /* SecurityContext context = new SecurityContext();
    var chain = Platform.script.resolve('ssl/fullchain.pem').toFilePath();
    var key = Platform.script.resolve('ssl/privkey.pem').toFilePath();
    context.useCertificateChain(chain);
    context.usePrivateKey(key); *

    //final server = Jaguar(securityContext: context);  // Serves the API at localhost:8080 by default
	final server = Jaguar();  // Serves the API at localhost:8080 by default

	
    server.putJson('/api/users/:user', Request_PutUser);
    server.postJson('/api/auth/:user', Request_authUser);

    server.staticFiles('/*', 'bin/static/build/');

    await server.serve(logRequests: true);

    pool = await new ConnectionPool(
    host: 'localhost', port: 3306,
    user: 'main', password: 'pass',
    db: 'dartdb', max: 5);

    print('Sever listening on port :8080');

    await pool.query('''
    CREATE TABLE IF NOT EXISTS users
    (
        username varchar(32) PRIMARY KEY UNIQUE,
        password varchar(512),
        ip varchar(64),
        id int AUTO_INCREMENT UNIQUE
    );''');
}

