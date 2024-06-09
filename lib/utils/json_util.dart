import 'dart:convert';

class JsonUtil {
  JsonDecoder decoder = const JsonDecoder();
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  static String encode(Object object) {
    return json.encode(object);
  }

  static dynamic decode(String jsonStr) {
    return json.decode(jsonStr);
  }
}
