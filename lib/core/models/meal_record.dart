class MealRecord {
  final String id;
  final String date; // yyyy-MM-dd
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final String name;
  final int calories;
  final double weightGrams;
  final String? imageUrl;
  final double protein; // grams
  final double carbs; // grams
  final double fat; // grams

  const MealRecord({
    required this.id,
    required this.date,
    required this.mealType,
    required this.name,
    required this.calories,
    required this.weightGrams,
    this.imageUrl,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  MealRecord copyWith({
    String? id,
    String? date,
    String? mealType,
    String? name,
    int? calories,
    double? weightGrams,
    String? imageUrl,
    double? protein,
    double? carbs,
    double? fat,
  }) {
    return MealRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      weightGrams: weightGrams ?? this.weightGrams,
      imageUrl: imageUrl ?? this.imageUrl,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'meal_type': mealType,
      'name': name,
      'calories': calories,
      'weight_grams': weightGrams,
      'image_url': imageUrl,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  factory MealRecord.fromMap(Map<String, dynamic> map) {
    return MealRecord(
      id: map['id'] as String,
      date: map['date'] as String,
      mealType: map['meal_type'] as String,
      name: map['name'] as String,
      calories: map['calories'] as int,
      weightGrams: (map['weight_grams'] as num?)?.toDouble() ?? 100.0,
      imageUrl: map['image_url'] as String?,
      protein: (map['protein'] as num?)?.toDouble() ?? 0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Mock food item for search
class FoodItem {
  final String name;
  final int caloriesPer100g;
  final String? imageUrl;
  final double protein;
  final double carbs;
  final double fat;

  const FoodItem({
    required this.name,
    required this.caloriesPer100g,
    this.imageUrl,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });
}

/// Pre-built mock food database
class MockFoodDatabase {
  static const List<FoodItem> foods = [
    FoodItem(
      name: 'White Rice (cooked)',
      caloriesPer100g: 130,
      protein: 2.7,
      carbs: 28,
      fat: 0.3,
      imageUrl: 'assets/icons/ic_whiterice.png',
    ),
    FoodItem(
      name: 'Maize / Corn (cooked)',
      caloriesPer100g: 96,
      protein: 3.4,
      carbs: 21,
      fat: 1.5,
      imageUrl: 'assets/icons/ic_maizecorn.png',
    ),
    FoodItem(
      name: 'Wheat Bread (white)',
      caloriesPer100g: 270,
      protein: 9,
      carbs: 49,
      fat: 3,
      imageUrl: 'assets/icons/ic_wheatbread.png',
    ),
    FoodItem(
      name: 'Potatoes (boiled)',
      caloriesPer100g: 87,
      protein: 1.9,
      carbs: 20,
      fat: 0.1,
      imageUrl: 'assets/icons/ic_potatoes.png',
    ),
    FoodItem(
      name: 'Sweet Potatoes (boiled)',
      caloriesPer100g: 86,
      protein: 1.6,
      carbs: 20,
      fat: 0.1,
      imageUrl: 'assets/icons/ic_sweetpotatoes.png',
    ),
    FoodItem(
      name: 'Cassava / Yuca (boiled)',
      caloriesPer100g: 160,
      protein: 1.4,
      carbs: 38,
      fat: 0.3,
      imageUrl: 'assets/icons/ic_cassava.png',
    ),
    FoodItem(
      name: 'Lentils (cooked)',
      caloriesPer100g: 116,
      protein: 9,
      carbs: 20,
      fat: 0.4,
      imageUrl: 'assets/icons/ic_lentils.png',
    ),
    FoodItem(
      name: 'Chicken Breast (cooked, skinless)',
      caloriesPer100g: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      imageUrl: 'assets/icons/ic_chickenbreast.png',
    ),
    FoodItem(
      name: 'Beef (lean, cooked)',
      caloriesPer100g: 250,
      protein: 26,
      carbs: 0,
      fat: 15,
      imageUrl: 'assets/icons/ic_beef.png',
    ),
    FoodItem(
      name: 'Pork (lean, cooked)',
      caloriesPer100g: 225,
      protein: 27,
      carbs: 0,
      fat: 12,
      imageUrl: 'assets/icons/ic_pork.png',
    ),
    FoodItem(
      name: 'Chicken Thigh',
      caloriesPer100g: 180,
      protein: 24,
      carbs: 0,
      fat: 9,
      imageUrl: 'assets/icons/ic_chickenthigh.png',
    ),
    FoodItem(
      name: 'Salmon (cooked)',
      caloriesPer100g: 208,
      protein: 22,
      carbs: 0,
      fat: 13,
      imageUrl: 'assets/icons/ic_salmon.png',
    ),
    FoodItem(
      name: 'Tuna (canned in water)',
      caloriesPer100g: 100,
      protein: 23,
      carbs: 0,
      fat: 0.5,
      imageUrl: 'assets/icons/ic_tuna.png',
    ),
    FoodItem(
      name: 'Shrimp (boiled)',
      caloriesPer100g: 100,
      protein: 21,
      carbs: 0.2,
      fat: 1.1,
      imageUrl: 'assets/icons/ic_shrimp.png',
    ),
    FoodItem(name: 'Eggs (70-80 kcal/egg)', caloriesPer100g: 143, protein: 12.6, carbs: 0.7, fat: 9.5),
    FoodItem(name: 'Apple', caloriesPer100g: 52, protein: 0.3, carbs: 13.8, fat: 0.2),
    FoodItem(name: 'Banana', caloriesPer100g: 89, protein: 1.1, carbs: 22.8, fat: 0.3),
    FoodItem(name: 'Broccoli', caloriesPer100g: 34, protein: 2.8, carbs: 6.6, fat: 0.4),
    FoodItem(name: 'Avocado', caloriesPer100g: 171, protein: 2, carbs: 8.5, fat: 14.7),
    FoodItem(name: 'Carrots', caloriesPer100g: 41, protein: 0.9, carbs: 9.6, fat: 0.2),
    FoodItem(name: 'Tomatoes', caloriesPer100g: 18, protein: 0.9, carbs: 3.9, fat: 0.2),
    FoodItem(name: 'Spinach (raw)', caloriesPer100g: 23, protein: 2.9, carbs: 3.6, fat: 0.4),
    FoodItem(name: 'Cabbage', caloriesPer100g: 25, protein: 1.3, carbs: 5.8, fat: 0.1),
    FoodItem(name: 'Onions', caloriesPer100g: 40, protein: 1.1, carbs: 9.3, fat: 0.1),
    FoodItem(name: 'Bell Peppers (red)', caloriesPer100g: 31, protein: 1, carbs: 6, fat: 0.3),
    FoodItem(name: 'Green Beans', caloriesPer100g: 31, protein: 1.8, carbs: 7.1, fat: 0.1),
    FoodItem(name: 'Pumpkin', caloriesPer100g: 26, protein: 1, carbs: 6.5, fat: 0.1),
    FoodItem(name: 'Bok Choy', caloriesPer100g: 13, protein: 1.5, carbs: 2.2, fat: 0.2),
    FoodItem(name: 'Mango', caloriesPer100g: 60, protein: 0.8, carbs: 15, fat: 0.4),
    FoodItem(name: 'Pineapple', caloriesPer100g: 50, protein: 0.5, carbs: 13, fat: 0.1),
    FoodItem(name: 'Watermelon', caloriesPer100g: 30, protein: 0.6, carbs: 7.6, fat: 0.2),
    FoodItem(name: 'Grapes', caloriesPer100g: 69, protein: 0.7, carbs: 18, fat: 0.2),
    FoodItem(name: 'Strawberries', caloriesPer100g: 32, protein: 0.7, carbs: 7.7, fat: 0.3),
    FoodItem(name: 'Kiwi', caloriesPer100g: 61, protein: 1.1, carbs: 15, fat: 0.5),
  ];

  static List<FoodItem> search(String query) {
    if (query.isEmpty) return foods;
    final lower = query.toLowerCase();
    return foods.where((f) => f.name.toLowerCase().contains(lower)).toList();
  }
}
