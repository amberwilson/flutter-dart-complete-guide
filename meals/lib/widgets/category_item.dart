import 'package:flutter/material.dart';

import '../models/category.dart';
import '../screens/category_meals_screen.dart';
import '../screens/category_meals_screen_args.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  void selectCategory(BuildContext context, Category category) {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (_) {
    //     return CategoryMealsScreen(
    //       category: category,
    //     );
    //   },
    // ));
    Navigator.of(context).pushNamed(
      CategoryMealsScreen.routeName,
      arguments: CategoryMealsScreenArgs(category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectCategory(context, category);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          category.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [category.color.withOpacity(0.7), category.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
