import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Bunu eklemeyi unutma
import '../l10n/app_localizations.dart';
import '../wiews/character_list_screen.dart';
import '../wiews/favorite_screen.dart';
import '../wiews/theme_view_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CharacterListScreen(),
    FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Çıkış sonrası MyApp içindeki authStateChanges dinleyicisi tetiklenip LoginScreen gösterilir.
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: loc.characters,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: loc.favorites,
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
