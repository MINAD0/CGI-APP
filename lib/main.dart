import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/recent_screen.dart'; // Correct reference to RecentArticlesScreen
import 'screens/saved_screen.dart';
import 'screens/theme_notifier.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bookmark_provider.dart';
import 'recent_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => RecentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Code Général des Impôts',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
        '/saved': (context) => SavedScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Home screen
    RecentScreen(), // Correctly referenced Recent screen
    SavedScreen(), // Saved articles screen
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto-Bold', // Replace with your desired font family
          color: isDarkMode ? Colors.blueAccent : Colors.cyanAccent,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto-Regular', // Replace with your desired font family
        ),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/house-solid.svg', // Path to the SVG file
              height: 20,
              width: 20,
              color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
            ),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/clock-rotate-left-solid.svg', // Path to the SVG file
              height: 20,
              width: 20,
              color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
            ),
            label: 'Récent',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bookmark-regular.svg', // Path to the SVG file
              height: 20,
              width: 20,
              color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
            ),
            label: 'Préférée',
          ),
        ],
      ),
    );
  }
}
