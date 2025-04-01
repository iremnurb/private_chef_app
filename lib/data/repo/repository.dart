import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/user_model.dart';

class UserRepository {
  //************************SIGN UP******************************
  Future<String> signUp(UserModel user) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/users/signup');
    try {
      print("Sending User Data: ${user.toJson()}");  // Eklenen kontrol

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return "Signup successful!";
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Signup failed!';
      }
    } catch (e) {
      print("Error in signup request: $e");
      return 'Error: ${e.toString()}';
    }
  }

  //************************lOGIN******************************
  Future<String> login(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/users/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return "Login successful!";
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Login failed!';
      }
    } catch (e) {
      print("Error in login request: $e");
      return 'Error: ${e.toString()}';
    }
  }
}
