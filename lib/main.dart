import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'wiews/login_screen.dart';
import 'wiews/home_screen.dart';
import 'wiewmodels/favorite_view_model.dart';
import 'wiewmodels/character_wiew_model.dart';
import 'wiews/theme_view_model.dart';

import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final favoriteViewModel = FavoriteViewModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterViewModel()),
        ChangeNotifierProvider(create: (_) => favoriteViewModel),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: MyApp(favoriteViewModel: favoriteViewModel),
    ),
  );
}

class MyApp extends StatefulWidget {
  final FavoriteViewModel favoriteViewModel;
  const MyApp({Key? key, required this.favoriteViewModel}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();

    // Firebase oturum değişikliğini dinle
    FirebaseAuth.instance.authStateChanges().listen((u) {
      setState(() {
        user = u;
      });

      if (u != null) {
        // Favorileri yükle ve anlık dinlemeye başla
        widget.favoriteViewModel.loadFavorites();
        widget.favoriteViewModel.startFavoritesListener();
      } else {
        // Oturum kapanınca dinlemeyi durdur
        widget.favoriteViewModel.stopFavoritesListener();
      }
    });
  }

  @override
  void dispose() {
    widget.favoriteViewModel.stopFavoritesListener(); // Güvenli çıkış
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick and Morty',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black),
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Lokalizasyon
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Giriş durumu kontrolü
      home: user == null
          ? LoginScreen(
        onLoginSuccess: () {
          setState(() {});
        },
      )
          : HomeScreen(),
    );
  }
}
