import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/diet_meal_model.dart';
import '../entity/favorite_model.dart';
import '../entity/meal_detail_model.dart';
import '../entity/recipe_model.dart';
import '../entity/user_model.dart';
import 'package:diyet/data/entity/diet_model.dart';
import 'package:diyet/data/entity/diyet_list_model.dart';

class UserRepository {
  //************************SIGN UP******************************
  Future<String> signUp(UserModel user) async {
    final url = Uri.parse('http://10.0.2.2:5002/api/users/signup');
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
  Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:5002/api/users/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        return null;
      }
    } catch (e) {
      print("Error in login request: $e");
      return null;
    }
  }


  /*Future<UserModel?> updateUser(UserModel user) async {
    final url = Uri.parse('http://10.0.2.2:5002/api/users/${user.id}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during update: $e");
      return null;
    }
  }*/

  Future<UserModel?> updateUser(UserModel updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5002/api/users/${updatedUser.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      print('Kullanıcı güncellenirken hata: $e');
      return null;
    }
  }

  //********WHATS IN MY FRIDGE MODE*****
  Future<List<RecipeModel>> fetchRecipesWithAdvancedFilter({
    required List<String> ingredients,
    required List<String> mealType,
    required int maxCalories,
    double? fat,
    double? protein,
    double? carbs,
    double? sugar,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5002/api/recipes/filter');

    final body = {
      'ingredients': ingredients,
      'mealType': mealType,
      'maxCalories': maxCalories,
      'macros': {
        if (fat != null) 'fat': fat,
        if (protein != null) 'protein': protein,
        if (carbs != null) 'carbs': carbs,
        if (sugar != null) 'sugar': sugar,
      },
    };
    print(jsonEncode(body));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> recipesJson = decoded['recipes'];
      return recipesJson.map((e) => RecipeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load recipes with filters');
    }
  }



//********TIME LIMIT MODE*****
  Future<List<RecipeModel>> fetchRecipesByTimeLimit(int totalMinutes) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:5002/api/recipes/by-time-limit"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"maxMinutes": totalMinutes}),
    );

    print("status code: ${response.statusCode}");
    print("response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["recipes"] as List)
          .map((e) => RecipeModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to fetch recipes by time");
    }
  }
}
class DietRepository {
  final String baseUrl = 'http://10.0.2.2:5002/api/diets'; // Android emulator için


  Future<DietModel?> createDietPlan(DietModel dietPlan) async {
    final url = Uri.parse('$baseUrl/create');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dietPlan.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return DietModel.fromJson(responseData);
      } else {
        print('Create failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Create error: $e');
      return null;
    }
  }

  Future<bool> createDietList(int userId) async {
    final url = Uri.parse('http://10.0.2.2:5002/api/diet-list');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      print(" Status Code: ${response.statusCode}");
      print(" Response: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print(" Hata: $e");
      return false;
    }
  }


  Future<List<DietListDay>> fetchDietList(int userId) async {
    final url = Uri.parse('http://10.0.2.2:5002/api/diet-list?userId=$userId'); //  PORT 5002

    final response = await http.get(url); //  GET method

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => DietListDay.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch diet list');
    }
  }

  Future<MealDetail> fetchMealDetail(int mealId) async {
    final url = Uri.parse('http://10.0.2.2:5002/api/meal-details?mealId=$mealId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MealDetail.fromJson(json);
    } else {
      throw Exception('Failed to fetch meal detail');
    }
  }
}

class FavoriteRepository {
  final String baseUrl = 'http://10.0.2.2:5002/api/favorites';

  Future<void> addFavorite(int userId, int recipeId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'recipeId': recipeId}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add to favorites: ${response.body}');
    }
  }

  Future<void> removeFavorite(int userId, int recipeId) async {
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'recipeId': recipeId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites: ${response.body}');
    }
  }

  Future<List<FavoriteModel>> fetchFavorites(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$userId'));
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => FavoriteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch favorites: ${response.body}');
    }
  }
}






