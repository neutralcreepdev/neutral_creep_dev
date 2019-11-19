import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HashCash {
  static Future<String> hash(String secret) async {
    bool fake = true;
    var bytes1, bytes2, bytes3, hmacSha256, digest;

    String md5HashKey, hash;
    bytes1 = utf8.encode(secret);

    while (fake) {
      hash = sha256.convert(bytes1).toString();
      bytes2 = utf8.encode(hash);
      md5HashKey = md5.convert(bytes2).toString();
      bytes3 = utf8.encode(md5HashKey);
      hmacSha256 = new Hmac(sha256, bytes3); // HMAC-SHA256
      digest = hmacSha256.convert(bytes1);
      print(digest);

      if (digest.toString().substring(0, 3) == "000")
        fake = false;
      else {
        var temp = bytes1;
        bytes1 = bytes2;
        bytes2 = temp;
      }
    }
    await Fluttertoast.showToast(msg: "Hash done: ${digest.toString()}");
    return digest.toString();
  }

  String hex(String code) {
    int length = code.length;
    String temp = "";
    while (length > 0) {
      if (code.substring(0, 4) == "0000")
        temp += "0";
      else if (code.substring(0, 4) == "0001")
        temp += "1";
      else if (code.substring(0, 4) == "0010")
        temp += "2";
      else if (code.substring(0, 4) == "0011")
        temp += "3";
      else if (code.substring(0, 4) == "0100")
        temp += "4";
      else if (code.substring(0, 4) == "0101")
        temp += "5";
      else if (code.substring(0, 4) == "0110")
        temp += "6";
      else if (code.substring(0, 4) == "0111")
        temp += "7";
      else if (code.substring(0, 4) == "1000")
        temp += "8";
      else if (code.substring(0, 4) == "1001")
        temp += "9";
      else if (code.substring(0, 4) == "1010")
        temp += "A";
      else if (code.substring(0, 4) == "1011")
        temp += "B";
      else if (code.substring(0, 4) == "1100")
        temp += "C";
      else if (code.substring(0, 4) == "1101")
        temp += "D";
      else if (code.substring(0, 4) == "1110")
        temp += "E";
      else if (code.substring(0, 4) == "1111") temp += "F";

      code = code.substring(4, length);
      length -= 4;
    }
    return temp;
  }

//HashCash - Flutter
//  void funt() {
//    bool fake = true;
//    String newPlaintext = "";
//    int nonce = 0;
//    String plainText = 'Ruiyang owe john 2|$nonce';
//    //print(plainText.codeUnits);
//    Map x = {};
//
//    int counter = 1;
//    while (counter != 3) {
//      String PTBinaryString = "";
//      for (int i = 0; i < plainText.length; i++) {
//        String w = plainText.codeUnitAt(i).toRadixString(2);
//        while (w.length < 8) w = "0" + w;
//        x = {i: w};
//        //print(w);
//        PTBinaryString += w;
//      }
//
//      //print(PTBinaryString);
//      //print("/n${PTBinaryString.length}");
//
////Padding
//      while (PTBinaryString.length % 128 != 0)
//        PTBinaryString = "0" + PTBinaryString;
//      //print("lemon$PTBinaryString");
//
//      int length = PTBinaryString.length;
//      String subPTbinaryStr = "";
//      String outputStr = "";
//
//      //print("size${PTBinaryString.length}");
//      String IVdateTime = "000000112019-10-19 21:01:35.34".substring(0, 16);
//
//      var iv = IV.fromUtf8(IVdateTime);
//
//      while (length > 128) {
//        length -= 128;
//        subPTbinaryStr = PTBinaryString.substring(0, 128);
//        //print("SubPTBinaryStr:$subPTbinaryStr");
//        PTBinaryString = PTBinaryString.substring(128, PTBinaryString.length);
//        newPlaintext = plainText;
//        while (newPlaintext.length % 16 != 0)
//          newPlaintext = newPlaintext + "\0";
//
//        String hexString = hex(subPTbinaryStr);
//        final key = Key.fromUtf8(hexString);
//        //print("key$hexString${hexString.length}");
//
//        final encrypter = Encrypter(AES(key));
//        final encrypted = encrypter.encrypt(newPlaintext, iv: iv);
//        outputStr = encrypted.base16;
//        //print(outputStr);
//
//        print(outputStr.substring(0, 16));
//        iv = IV.fromUtf8(outputStr.substring(0, 16));
//      }
//      String encryptionKey = PTBinaryString;
//      String hexString = hex(encryptionKey);
//      final key = Key.fromUtf8(hexString);
//
//      outputStr = "";
//      newPlaintext = plainText;
//      while (newPlaintext.length % 16 != 0) newPlaintext = newPlaintext + "\0";
//      final encrypter = Encrypter(AES(key));
//      final encrypted = encrypter.encrypt(newPlaintext, iv: iv);
//      outputStr = encrypted.base16;
//
//      String finalOutput = "";
//      finalOutput = outputStr;
//      String cipherCheck = outputStr.substring(0, 3);
//      String zero = "000";
//
//      if (cipherCheck == zero) {
//        // System.out.println(outputStr);
//        print("Value found!");
//        print("Plaintext + nonce: " + plainText);
//        print("Hash: " + outputStr);
//        fake = false;
//      } else {
//        print(outputStr);
//      }
//
//      iv = IV.fromUtf8(outputStr.substring(0, 16));
//      nonce++;
//      counter++;
//    }
//  }
}
