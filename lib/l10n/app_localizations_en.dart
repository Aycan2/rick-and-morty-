// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rick and Morty';

  @override
  String get characters => 'Characters';

  @override
  String get favorites => 'Favorites';

  @override
  String get searchHint => 'Search...';

  @override
  String get noFavorites => 'No favorite characters yet.';

  @override
  String get noFavoritesFound =>
      'No favorite characters found for your search.';

  @override
  String get speciesLabel => 'Species:';

  @override
  String get statusLabel => 'Status:';

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoading => 'Failed to load data.';

  @override
  String get favoriteButtonLabel => 'Toggle Favorite';

  @override
  String get favoriteAdded => 'Added to favorites';

  @override
  String get favoriteRemoved => 'Removed from favorites';

  @override
  String get noCharactersLoaded =>
      'Characters could not be loaded or there are no characters.';

  @override
  String get noCharactersFound => 'No characters found for your search.';
}
