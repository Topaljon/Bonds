import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> responseUrlBonds(String url) async {
  final urlBonds = Uri.parse(url);
  final response = await http.Client().get(urlBonds);
  final list = jsonDecode(response.body) as Map<String, dynamic>;
  return list;
}
