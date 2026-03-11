import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/meal_record.dart';
import '../../core/providers/nutrition_provider.dart';
import '../../core/services/food_service.dart';
import '../../core/theme/app_colors.dart';

class FoodSelectionScreen extends ConsumerStatefulWidget {
  const FoodSelectionScreen({super.key});

  @override
  ConsumerState<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends ConsumerState<FoodSelectionScreen> {
  final Set<FoodItem> _selectedFoods = {};
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final searchResults = MockFoodDatabase.search(_searchQuery);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'List food',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (_selectedFoods.isNotEmpty)
            TextButton(
              onPressed: _addSelectedFoods,
              child: const Text(
                'Add',
                style: TextStyle(
                  color: AppColors.activityBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: searchResults.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: 72,
                color: Color(0xFFF0F0F0),
              ),
              itemBuilder: (context, index) {
                final food = searchResults[index];
                final isSelected = _selectedFoods.contains(food);

                return ListTile(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFoods.remove(food);
                      } else {
                        _selectedFoods.add(food);
                      }
                    });
                  },
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(8),
                      image: food.imageUrl != null
                          ? DecorationImage(
                              image: food.imageUrl!.startsWith('assets/')
                                  ? AssetImage(food.imageUrl!) as ImageProvider
                                  : NetworkImage(food.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: food.imageUrl == null
                        ? const Icon(Icons.restaurant_rounded, color: Colors.grey, size: 20)
                        : null,
                  ),
                  title: Text(
                    food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    '${food.caloriesPer100g} kcal / 100g',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedFoods.add(food);
                        } else {
                          _selectedFoods.remove(food);
                        }
                      });
                    },
                    activeColor: AppColors.activityBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addSelectedFoods() async {
    final selectedMealType = ref.read(selectedMealTypeProvider);
    
    for (final food in _selectedFoods) {
      await FoodService.addMeal(
        mealType: selectedMealType,
        name: food.name,
        calories: food.caloriesPer100g, // Default 100g calories
        weightGrams: 100.0,
        imageUrl: food.imageUrl,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
      );
    }
    
    ref.invalidate(todayMealsProvider);
    ref.invalidate(todayCaloriesConsumedProvider);
    
    if (mounted) Navigator.pop(context);
  }
}
