import 'dart:io';
import 'package:http/http.dart' as http;

class Server {
  getRequest({String? endPoint}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return await http.get(Uri.parse(endPoint!), headers: _getHttpHeaders());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  static Map<String, String> _getHttpHeaders() {
    Map<String, String> headers = Map<String, String>();
    headers['content-type'] = 'application/json';
    headers['Accept'] = 'application/json';
    return headers;
  }
}
