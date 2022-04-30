import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Meal> favourites;

  const FavouritesScreen({Key? key, required this.favourites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return favourites.isEmpty
        ? Center(child: Text('You have no favourites yet.'))
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return MealItem(
                meal: favourites[index],
                removeHandler: (mealId) {},
              );
            },
            itemCount: favourites.length,
          );
  }
}
