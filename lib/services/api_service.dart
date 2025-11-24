import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';


class ApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';


  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_base/categories.php');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    final j = json.decode(res.body) as Map<String, dynamic>;
    final list = j['categories'] as List<dynamic>;
    return list.map((e) => Category.fromJson(e)).toList();
  }


  static Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$_base/filter.php?c=$category');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed to load meals');
    final j = json.decode(res.body) as Map<String, dynamic>;
    final list = j['meals'] as List<dynamic>?;
    if (list == null) return [];
    return list.map((e) => MealSummary.fromJson(e)).toList();
  }


// Search across all meals, then filter by category if provided
  static Future<List<MealSummary>> searchMeals(String query, {String? category}) async {
    if (query.trim().isEmpty) return [];
    final url = Uri.parse('$_base/search.php?s=${Uri.encodeQueryComponent(query)}');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed to search meals');
    final j = json.decode(res.body) as Map<String, dynamic>;
    final list = j['meals'] as List<dynamic>?;
    if (list == null) return [];
    final meals = list.map((e) => MealSummary.fromJson(e)).toList();
    if (category == null) return meals;
    return meals.where((m) => m.category?.toLowerCase() == category.toLowerCase()).toList();
  }


static Future<MealDetail?> fetchMealDetail(String id) async {
  final url = Uri.parse('$_base/lookup.php?i=${Uri.encodeComponent(id)}');
  final res = await http.get(url);

  print('=== fetchMealDetail raw body for id=$id ===');
  print(res.body);
  print('=== end of body ===');

  if (res.statusCode != 200) throw Exception('Failed to load meal');
  final j = json.decode(res.body) as Map<String, dynamic>;
  final list = j['meals'] as List<dynamic>?;
  if (list == null || list.isEmpty) return null;
  return MealDetail.fromJson(list[0] as Map<String, dynamic>);
}



  static Future<MealDetail?> fetchRandomMeal() async {
    final url = Uri.parse('$_base/random.php');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed to load random meal');
    final j = json.decode(res.body) as Map<String, dynamic>;
    final list = j['meals'] as List<dynamic>?;
    if (list == null || list.isEmpty) return null;
    return MealDetail.fromJson(list[0] as Map<String, dynamic>);
  }
}