import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../models/meal_affordability.dart';
import '../models/meal_complexity.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/meal_detail_screen_args.dart';
import '../screens/meal_detail_screen_pop_args.dart';

class MealItem extends StatelessWidget {
  final Meal meal;
  final Function(String) removeHandler;
  const MealItem({Key? key, required this.meal, required this.removeHandler})
      : super(key: key);

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context)
        .pushNamed(
      MealDetailScreen.routeName,
      arguments: MealDetailScreenArgs(meal),
    )
        .then((result) {
      if (result is MealDetailScreenPopArgs) {
        print('then....');
        // removeHandler(result.mealId);
      }
    });
  }

  String get complexityText {
    switch (meal.complexity) {
      case MealComplexity.Simple:
        return 'Simple';
      case MealComplexity.Challenging:
        return 'Challenging';
      case MealComplexity.Hard:
        return 'Hard';
      default:
        return '🤷‍♀️';
    }
  }

  String get affordabilityText {
    switch (meal.affordability) {
      case MealAffordability.Affordable:
        return 'Affordable';
      case MealAffordability.Pricey:
        return 'Pricey';
      case MealAffordability.Luxurious:
        return 'Luxurious';
      default:
        return '🤷‍♀️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context, meal),
      child: Card(
        child: Column(
          children: [
            Stack(children: [
              ClipRRect(
                child: Image.network(
                  meal.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Container(
                  width: 300,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Text(
                    meal.title,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(
                        width: 6,
                      ),
                      Text('${meal.duration} min'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(
                        width: 6,
                      ),
                      Text(complexityText),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.money),
                      SizedBox(
                        width: 6,
                      ),
                      Text(affordabilityText),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
