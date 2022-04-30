import 'package:flutter/material.dart';

import 'dummy_data.dart';
import 'models/meal.dart';
import 'models/meal_affordability.dart';
import 'models/meal_complexity.dart';
import 'screens/categories_screen.dart';
import 'screens/category_meals_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'vegetarian': false,
    'vegan': false,
    'lactose': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favourites = [
    Meal(
      id: 'm2',
      categories: [
        'c2',
      ],
      title: 'Toast Hawaii',
      affordability: MealAffordability.Affordable,
      complexity: MealComplexity.Simple,
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      duration: 10,
      ingredients: [
        '1 Slice White Bread',
        '1 Slice Ham',
        '1 Slice Pineapple',
        '1-2 Slices of Cheese',
        'Butter'
      ],
      steps: [
        'Butter one side of the white bread',
        'Layer ham, the pineapple and cheese on the white bread',
        'Bake the toast for round about 10 minutes in the oven at 200°C'
      ],
      isGlutenFree: false,
      isVegan: false,
      isVegetarian: false,
      isLactoseFree: false,
    )
  ];

  void _setFilters(Map<String, bool> filters) {
    setState(() {
      _filters = filters;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten']! && !meal.isGlutenFree) {
          return false;
        }

        if (_filters['vegetarian']! && !meal.isVegetarian) {
          return false;
        }

        if (_filters['vegan']! && !meal.isVegan) {
          return false;
        }

        if (_filters['lactose']! && !meal.isLactoseFree) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final existingIndex = _favourites.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favourites.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favourites.add(DUMMY_MEALS.firstWhere(((meal) => meal.id == mealId)));
      });
    }
  }

  bool _isMealFavourite(String mealId) {
    return _favourites.any((meal) => meal.id == mealId);
  }

  final ThemeData theme = ThemeData(
    primarySwatch: Colors.pink,
    canvasColor: Color.fromRGBO(255, 254, 229, 1),
    fontFamily: 'Raleway',
    textTheme: ThemeData.light().textTheme.copyWith(
          bodyText1: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
          ),
          bodyText2: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
          ),
          headline1: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.amber),
      ),
      // home: TabsScreen(),
      routes: {
        TabsScreen.routeName: (context) => TabsScreen(favourites: _favourites),
        CategoriesScreen.routeName: (context) => CategoriesScreen(),
        CategoryMealsScreen.routeName: (context) =>
            CategoryMealsScreen(availableMeals: _availableMeals),
        MealDetailScreen.routeName: (context) => MealDetailScreen(
              toggleFavouriteHandler: _toggleFavourite,
              isMealFavourite: _isMealFavourite,
            ),
        FiltersScreen.routeName: (context) => FiltersScreen(
              saveHandler: _setFilters,
              currentFilters: _filters,
            ),
      },
      // onGenerateRoute: (settings) {
      //   // allows dynamically handling routing
      //   print(settings.arguments);
      //   return MaterialPageRoute(builder: (context) => CategoriesScreen());
      // },
      // onUnknownRoute: (settings) {
      //   // happens if can't find a route at all then can have a fallback
      //   return MaterialPageRoute(builder: (context) => CategoriesScreen());
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: Center(
        child: Text('Navigation Time!'),
      ),
    );
  }
}
