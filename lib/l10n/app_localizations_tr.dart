// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Rick ve Morty';

  @override
  String get characters => 'Karakterler';

  @override
  String get favorites => 'Favoriler';

  @override
  String get searchHint => 'Ara...';

  @override
  String get noFavorites => 'Henüz favori karakter yok.';

  @override
  String get noFavoritesFound => 'Aramaya uygun favori karakter bulunamadı.';

  @override
  String get speciesLabel => 'Tür:';

  @override
  String get statusLabel => 'Durum:';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get errorLoading => 'Veri yüklenemedi.';

  @override
  String get favoriteButtonLabel => 'Favori Ekle/Çıkar';

  @override
  String get favoriteAdded => 'Favorilere eklendi';

  @override
  String get favoriteRemoved => 'Favorilerden çıkarıldı';

  @override
  String get noCharactersLoaded =>
      'Karakterler yüklenemedi veya hiç karakter yok.';

  @override
  String get noCharactersFound => 'Aramanıza uygun karakter bulunamadı.';
}
