import 'package:flutter/material.dart';

import 'meal_detail_screen_args.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';
  final void Function(String) toggleFavouriteHandler;
  final bool Function(String) isMealFavourite;

  const MealDetailScreen({
    Key? key,
    required this.toggleFavouriteHandler,
    required this.isMealFavourite,
  }) : super(key: key);

  Widget buildSectionTitle(BuildContext context, String title) {
    return Container(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MealDetailScreenArgs;
    final meal = args.displayedMeal;

    final isFavourite = isMealFavourite(meal.id);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              meal.title,
              style: Theme.of(context).textTheme.headline1,
            ),
            if (isFavourite) Icon(Icons.star),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              meal.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          buildSectionTitle(
            context,
            'Ingredients',
          ),
          buildContainer(
            ListView.builder(
              itemBuilder: (ctx, index) => Card(
                color: Theme.of(context).highlightColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Text(
                    meal.ingredients[index],
                  ),
                ),
              ),
              itemCount: meal.ingredients.length,
            ),
          ),
          buildSectionTitle(
            context,
            'Steps',
          ),
          buildContainer(
            ListView.builder(
              itemBuilder: (ctx, index) => Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('${(index + 1)}'),
                    ),
                    title: Text(meal.steps[index]),
                  ),
                  Divider(),
                ],
              ),
              itemCount: meal.steps.length,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isMealFavourite(meal.id) ? Icons.star : Icons.star_border),
        onPressed: () {
          toggleFavouriteHandler(meal.id);
        },
      ),
    );
  }
}
