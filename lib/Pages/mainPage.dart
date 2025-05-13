import 'package:flutter/material.dart';
import '../meal_api.dart';
import '../models/meal.dart';
import '../navigations.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //appBar: AppBar(title: Text("TheMealDB API Example")),
        body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: MealApi.findRecipesByIngredients(["chicken"]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Ошибка: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Рецепты не найдены");
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final meal = snapshot.data![index];
                    return ListTile(
                      leading: Image.network(meal['strMealThumb'], width: 50),
                      title: Text(meal['strMeal']),
                      subtitle: Text("Категория: ${meal['strCategory']}"),
                      onTap: () {
                        Navigations.navigateToInfoFoodPage(
                          context,
                          Meal(
                            id: meal['idMeal'] ?? '',
                            name: meal['strMeal'] ?? '',
                            category: meal['strCategory'] ?? '',
                            area: meal['strArea'] ?? '',
                            instructions: meal['strInstructions'] ?? '',
                            imageUrl: meal['strMealThumb'] ?? '',
                            ingredients: List<String>.generate(20, (i) => meal['strIngredient${i + 1}'] ?? '')
                                .where((ingredient) => ingredient.isNotEmpty)
                                .toList(),
                            measures: List<String>.generate(20, (i) => meal['strMeasure${i + 1}'] ?? '')
                                .where((measure) => measure.isNotEmpty)
                                .toList(),
                            ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}