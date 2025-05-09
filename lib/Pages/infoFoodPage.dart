// screens/meal_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/meal.dart';

class InfoFoodPage extends StatelessWidget {
  final Meal meal;

  const InfoFoodPage({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Изображение блюда
            Image.network(
              meal.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            // 2. Основная информация
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(Icons.category, meal.category),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.place, meal.area),
                    ],
                  ),

                  // 3. Секция с ингредиентами
                  const SizedBox(height: 24),
                  Text(
                    'Ингредиенты:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildIngredientsList(),

                  // 4. Инструкции приготовления
                  const SizedBox(height: 24),
                  Text(
                    'Инструкции:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.instructions,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Виджет для отображения чипсов с информацией
  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
    );
  }

  // Виджет для списка ингредиентов
  Widget _buildIngredientsList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(meal.ingredients.length, (index) {
        return Chip(
          label: Text(
            '${meal.ingredients[index]} - ${meal.measures[index]}',
          ),
          backgroundColor: Colors.orange[50],
        );
      }),
    );
  }
}