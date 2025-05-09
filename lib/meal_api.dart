import 'dart:convert';
import 'package:http/http.dart' as http;

// Класс для работы с TheMealDB API
class MealApi {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1";

  // 1. Поиск рецептов по одному ингредиенту
  static Future<List<dynamic>> getMealsByIngredient(String ingredient) async {
    final response = await http.get(Uri.parse("$_baseUrl/filter.php?i=$ingredient"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception("Ошибка загрузки данных: ${response.statusCode}");
    }
  }

  // 2. Получение полного рецепта по ID
  static Future<Map<String, dynamic>> getMealDetails(String mealId) async {
    final response = await http.get(Uri.parse("$_baseUrl/lookup.php?i=$mealId"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'][0]; // Возвращаем первый найденный рецепт
    } else {
      throw Exception("Ошибка загрузки данных: ${response.statusCode}");
    }
  }

  // 3. Поиск рецептов, содержащих несколько ингредиентов (фильтрация вручную)
  static Future<List<Map<String, dynamic>>> findRecipesByIngredients(List<String> ingredients) async {
    final List<Map<String, dynamic>> matchingRecipes = [];

    // Получаем рецепты по первому ингредиенту
    final meals = await getMealsByIngredient(ingredients[0]);

    // Для каждого рецепта проверяем наличие остальных ингредиентов
    for (var meal in meals) {
      final mealDetails = await getMealDetails(meal['idMeal']);
      final List<String> mealIngredients = [];

      // Собираем все ингредиенты рецепта (их может быть до 20)
      for (int i = 1; i <= 20; i++) {
        final ingredient = mealDetails['strIngredient$i'];
        if (ingredient != null && ingredient.isNotEmpty) {
          mealIngredients.add(ingredient.toLowerCase());
        }
      }

      // Проверяем, есть ли все нужные ингредиенты
      bool containsAll = ingredients.every((ing) => mealIngredients.contains(ing.toLowerCase()));
      if (containsAll) {
        matchingRecipes.add(mealDetails);
      }
    }

    return matchingRecipes;
  }
}