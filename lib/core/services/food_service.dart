import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/meal_record.dart';
import 'database_service.dart';

class FoodService {
  static const _uuid = Uuid();

  static Future<List<MealRecord>> getMealsForToday() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return DatabaseService.getMealsByDate(today);
  }

  static Future<List<MealRecord>> getMealsForDate(String date) async {
    return DatabaseService.getMealsByDate(date);
  }

  static Future<MealRecord> addMeal({
    required String mealType,
    required String name,
    required int calories,
    required double weightGrams,
    String? imageUrl,
    double protein = 0,
    double carbs = 0,
    double fat = 0,
    String? date,
  }) async {
    final meal = MealRecord(
      id: _uuid.v4(),
      date: date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      mealType: mealType,
      name: name,
      calories: calories,
      weightGrams: weightGrams,
      imageUrl: imageUrl,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
    await DatabaseService.insertMeal(meal);
    return meal;
  }

  static Future<void> updateMealWeight(String id, double grams, int caloriesPer100g) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final meals = await DatabaseService.getMealsByDate(today);
    final meal = meals.firstWhere((m) => m.id == id);
    
    final newCalories = (grams * caloriesPer100g / 100).round();
    final updatedMeal = meal.copyWith(
      weightGrams: grams,
      calories: newCalories,
    );
    await DatabaseService.updateMeal(updatedMeal);
  }

  static Future<void> updateMeal(MealRecord meal) async {
    await DatabaseService.updateMeal(meal);
  }

  static Future<void> deleteMeal(String id) async {
    await DatabaseService.deleteMeal(id);
  }

  static Future<int> getTotalCaloriesForToday() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return DatabaseService.getTotalCaloriesConsumed(today);
  }

  static Future<Map<String, double>> getMacroBreakdown(String date) async {
    final meals = await DatabaseService.getMealsByDate(date);
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    for (final meal in meals) {
      totalProtein += meal.protein;
      totalCarbs += meal.carbs;
      totalFat += meal.fat;
    }
    return {
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }

  static List<FoodItem> searchFood(String query) {
    return MockFoodDatabase.search(query);
  }
}
