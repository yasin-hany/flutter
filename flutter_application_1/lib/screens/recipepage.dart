
import 'dart:convert';
import 'package:flutter_application_1/model/class.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  static const String _randomRecipeUrl = 'https://www.themealdb.com/api/json/v1/1/random.php';
  Future<Recipe> fetchRandomRecipe() async {
    try {
      final response = await http.get(Uri.parse(_randomRecipeUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return Recipe.fromJson(data);
        } else {
          throw Exception('no meals'); 
        }
      } else {
        throw Exception('loading erorr ${response.statusCode}'); 
      }
    } catch (z) {
      print('Error $z');
      throw Exception('erorr in network'); 
    }
  }
}