import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // GANTI IP INI SESUAI ALAMAT LAPTOP KAMU
 static const String baseUrl = 'http://localhost:8080'; 

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      // Header ini penting untuk CI4
      headers: {"Content-Type": "application/x-www-form-urlencoded"}, 
      body: data,
    );
    return _processResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: data,
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  }
}