import 'package:http/http.dart' as http;


abstract interface class HttpClientBridgeInterface {
  Future<String> fetchData(String url);
  Future<String> postData(String url, Map<String, String> body);
}

class HttpClientBridge implements HttpClientBridgeInterface {
  @override
  Future<String> fetchData(String url) async {
    var response = await http.get(Uri.parse('https://www.fussball.de$url'));

    if (response.body != '') {
      return response.body;
    }

    throw Exception('Error on URL: https://www.fussball.de$url');
  }

  @override
  Future<String> postData(String url, Map<String, String> body) async {
    var response = await http.post(
      Uri.parse('https://www.fussball.de$url'),
      body: body,
    );

    if (response.body != '') {
      return response.body;
    }

    throw Exception('Error on URL: https://www.fussball.de$url');
  }
}
