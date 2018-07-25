import 'dart:typed_data';

import 'package:cryptoutils/cryptoutils.dart';
import '../../../pointycastle/api.dart' show KeyParameter;
import '../../../pointycastle/digests/sha512.dart';
import '../../../pointycastle/key_derivators/api.dart' show Pbkdf2Parameters;
import '../../../pointycastle/key_derivators/pbkdf2.dart';
import '../../../pointycastle/macs/hmac.dart';
import '../../../pointycastle/random/fortuna_random.dart';

import '../algorithm.dart';

class PBKDF2 extends Algorithm {
  static String id = 'pcks';

  final int blockLength;
  final int iterationCount;
  final int desiredKeyLength;

  PBKDF2KeyDerivator _derivator;
  Uint8List _salt;

  PBKDF2(
      {this.blockLength = 64,
      this.iterationCount = 10000,
      this.desiredKeyLength = 64,
      String salt = null}) {
    final rnd = new FortunaRandom()..seed(new KeyParameter(new Uint8List(32)));

    _salt = salt == null ? rnd.nextBytes(32) : CryptoUtils.hexToBytes(salt);

    _derivator =
        new PBKDF2KeyDerivator( new HMac(new SHA512Digest(), blockLength) )
          ..init(new Pbkdf2Parameters(_salt, iterationCount, desiredKeyLength));
  }

  String process(String password) {
    final bytes =
        _derivator.process(new Uint8List.fromList(password.codeUnits));

    return encode(
      id,
      [blockLength, iterationCount, desiredKeyLength],
      CryptoUtils.bytesToHex(_salt),
      CryptoUtils.bytesToHex(bytes),
    );
  }
}
