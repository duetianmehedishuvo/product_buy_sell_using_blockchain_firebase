import 'package:encryptor/encryptor.dart';

var key = 'meektec_fontend_feedback_apps_secret_key_112132e2232ju2h3u2';

String encryptedText(String plainText) {
  return Encryptor.encrypt(key, plainText);
}

String decryptedText(String plainText) {
  return Encryptor.decrypt(key, plainText);
}
