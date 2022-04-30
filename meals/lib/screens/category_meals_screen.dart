import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import 'category_meals_screen_args.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';
  final List<Meal> availableMeals;

  const CategoryMealsScreen({Key? key, required this.availableMeals})
      : super(key: key);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late Category _category;
  late List<Meal> _meals;
  var _loadedInitData = false;

  // @override
  // void initState() {
  //   final args =
  //       ModalRoute.of(context)!.settings.arguments as CategoryMealsScreenArgs;
  //   _category = args.category;
  //   _meals = DUMMY_MEALS
  //       .where((meal) => meal.categories.contains(_category.id))
  //       .toList();

  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final args =
          ModalRoute.of(context)!.settings.arguments as CategoryMealsScreenArgs;
      _category = args.category;
      _meals = widget.availableMeals
          .where((meal) => meal.categories.contains(_category.id))
          .toList();

      _loadedInitData = true;
    }

    super.didChangeDependencies();
  }

  void _removeMeal(String mealId) {
    setState(() {
      _meals.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _category.color,
        title: Text(
          'Category: ' + _category.title,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return MealItem(
            meal: widget.availableMeals[index],
            removeHandler: _removeMeal,
          );
        },
        itemCount: widget.availableMeals.length,
      ),
    );
  }
}
