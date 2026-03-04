class AppConstants {
  AppConstants._();

  // Database
  static const String databaseName = 'fitlife.db';
  static const int databaseVersion = 1;

  // Calorie Calculation
  static const double caloriesPerStep = 0.04; // base factor
  static const double defaultWeight = 70.0; // kg
  static const double runningMET = 9.8; // MET for running ~6mph

  // Step Goal
  static const int defaultStepGoal = 10000;
  static const int defaultCalorieTarget = 2000;

  // MET Values for activities (approximate)
  static const Map<String, double> metValues = {
    'walking': 3.5,
    'running': 9.8,
    'cycling': 7.5,
    'trekking': 6.0,
  };

  // Meal Types
  static const String breakfast = 'Breakfast';
  static const String lunch = 'Lunch';
  static const String dinner = 'Dinner';
  static const String snack = 'Snack';

  static const List<String> mealTypes = [breakfast, lunch, dinner, snack];
}
