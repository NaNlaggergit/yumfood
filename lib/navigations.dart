import 'package:flutter/material.dart';
import './pages/infoFoodPage.dart';
import './models/meal.dart';

class Navigations {
  static void navigateToInfoFoodPage(BuildContext context, Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoFoodPage(meal: meal),
      ),
    );
  }
}