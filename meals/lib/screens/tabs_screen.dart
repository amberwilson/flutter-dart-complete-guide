import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/main_drawer.dart';
import 'categories_screen.dart';
import 'favourites_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/';
  final List<Meal> favourites;

  const TabsScreen({Key? key, required this.favourites}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<TabScreen> _screens = [];
  int _selectedPageIndex = 0;

  @override
  initState() {
    _screens = [
      TabScreen(
        screenTitle: 'Categories',
        screen: CategoriesScreen(),
        tabTitle: 'Categories',
        tabIconData: Icons.category,
      ),
      TabScreen(
        screenTitle: 'Your Favourites',
        screen: FavouritesScreen(favourites: widget.favourites),
        tabTitle: 'Favourites',
        tabIconData: Icons.star,
      ),
    ];

    super.initState();
  }

  void _selectPage(int screenIndex) {
    setState(() {
      _selectedPageIndex = screenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedPageIndex].screenTitle),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: _screens[_selectedPageIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        items: _screens
            .map((tabScreen) => BottomNavigationBarItem(
                  icon: Icon(tabScreen.tabIconData),
                  label: tabScreen.tabTitle,
                ))
            .toList(),
        onTap: _selectPage,
      ),
    );

    /* return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meals'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.category),
                text: 'Categories',
              ),
              Tab(
                icon: Icon(Icons.star),
                text: 'Favourites',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CategoriesScreen(),
            FavouritesScreen(),
          ],
        ),
      ),
    );*/
  }
}

class TabScreen {
  final String screenTitle;
  final Widget screen;
  final String tabTitle;
  final IconData tabIconData;

  TabScreen({
    required this.screenTitle,
    required this.screen,
    required this.tabTitle,
    required this.tabIconData,
  });
}
