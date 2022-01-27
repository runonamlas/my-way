import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/screens/home/home_choose_city_screen/cities_screen.dart';
import 'package:my_way/screens/home/home_splash_screen/home_screen.dart';
import 'package:my_way/screens/home/home_tour_screen/tour_list_screen.dart';
import 'package:my_way/screens/saved/saved_screen.dart';
import 'package:my_way/screens/favourite/favourite_screen.dart';
import 'package:my_way/screens/profile/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final CityModel hasCity;
  BottomNavBar({@required this.hasCity, Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  List<int> history = [0];
  int _selectedIndex = 0;
  TabController _tabController;
  List<Widget> mainTabs;

  List<BuildContext> navStack = [null, null, null, null]; // one buildContext for each tab to store history  of navigation

  Widget selectHomeScreen() {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
        // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
        navStack[0] = context;
        if (widget.hasCity != null) {
          return HomeScreen(city: widget.hasCity);
        }
        return CitiesScreen();
      });
    });
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    mainTabs = <Widget>[
      selectHomeScreen(),
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
          navStack[1] = context;
          return FavouriteScreen();
        });
      }),
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
          navStack[2] = context;
          return SavedScreen(
              //cityInformation: 'istanbul',
              );
        });
      }),
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
          navStack[3] = context;
          return ProfileScreen();
        });
      }),
    ];
    super.initState();
  }

  final List<BottomNavigationBarRootItem> bottomNavigationBarRootItems = [
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        activeIcon: Icon(
          IconData(0xe900, fontFamily: 'home'),
        ),
        icon: Icon(
          IconData(0xe900, fontFamily: 'home-outline'),
        ),
      ),
    ),
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        activeIcon: Icon(
          IconData(0xe900, fontFamily: 'heart'),
        ),
        icon: Icon(
          IconData(0xe900, fontFamily: 'heart-outline'),
        ),
      ),
    ),
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        activeIcon: Icon(
          IconData(0xe900, fontFamily: 'bookmark'),
        ),
        icon: Icon(
          IconData(0xe901, fontFamily: 'bookmark-outline'),
        ),
      ),
    ),
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        activeIcon: Icon(
          IconData(0xe900, fontFamily: 'account'),
        ),
        icon: Icon(
          IconData(0xe900, fontFamily: 'account-outline'),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(navStack[_tabController.index]).canPop()) {
          Navigator.of(navStack[_tabController.index]).pop();
          setState(() {
            _selectedIndex = _tabController.index;
          });
          return false;
        } else {
          if (history.last == 0) {
            setState(() {
              _selectedIndex = 0;
            });
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          } else {
            setState(() {
              history.removeLast();
              _tabController.index = history.last;
              _selectedIndex = _tabController.index;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: mainTabs,
        ),
        bottomNavigationBar: CupertinoTabBar(
          items: bottomNavigationBarRootItems.map((e) => e.bottomNavigationBarItem).toList(),
          activeColor: kPrimaryColor,
          inactiveColor: kPrimaryColor.withOpacity(0.8),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    _tabController.index = index;
    setState(() {
      _selectedIndex = index;
      history.add(index);
    });
  }
}

class BottomNavigationBarRootItem {
  final String routeName;
  final NestedNavigator nestedNavigator;
  final BottomNavigationBarItem bottomNavigationBarItem;

  BottomNavigationBarRootItem({
    @required this.routeName,
    @required this.nestedNavigator,
    @required this.bottomNavigationBarItem,
  });
}

abstract class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  NestedNavigator({Key key, @required this.navigatorKey}) : super(key: key);
}

class HomeNavigator extends NestedNavigator {
  HomeNavigator({Key key, @required GlobalKey<NavigatorState> navigatorKey})
      : super(
          key: key,
          navigatorKey: navigatorKey,
        );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => CitiesScreen();
            break;
          case '/home/1':
            builder = (BuildContext context) => HomeScreen(
                  city: null,
                );
            break;
          case '/favourite':
            builder = (BuildContext context) => FavouriteScreen();
            break;
          case '/saved':
            builder = (BuildContext context) => SavedScreen(
                //cityInformation: 'istanbul',
                );
            break;
          case '/user':
            builder = (BuildContext context) => ProfileScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      },
    );
  }
}
