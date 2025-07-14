import 'dart:async'; // debounce için eklendi
import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../services/character_service.dart';
import '../models/character_response.dart';

class CharacterViewModel extends ChangeNotifier {
  List<Character> characters = []; // Karakter listesi
  String? _nextPageUrl; // sayfalama için sonraki sayfa url
  bool isLoading = false;

  Map<String, String> _filters = {}; // filtreler
  Timer? _debounce; //  debounce timer aramada hızlı yazmayı engeller donma azalır

  CharacterViewModel() {
    _filters.clear(); // başlangıçta filtreyi temizle
    loadInitialCharacters(); // ilk veri yüklenir
  }

  String _buildUrl() {
    final baseUrl = 'https://rickandmortyapi.com/api/character';
    if (_filters.isEmpty) {
      return baseUrl;
    }
    final uri = Uri.parse(baseUrl).replace(queryParameters: _filters);
    return uri.toString(); // filtreler ile url hazırlanır
  }

  // Kullanıcı arama kutusuna yazdıkça çağırılacak
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      applyFiltersAndReload(query);
    });
  }

  Future<void> applyFiltersAndReload(String query) async {
    _parseQuery(query);
    await loadInitialCharacters();
  }

  void _parseQuery(String query) {
    _filters.clear();
    if (query.isEmpty) return;

    final words = query.toLowerCase().split(' ').where((s) => s.isNotEmpty).toList();
    final nameParts = <String>[];

    final possibleStatus = ['alive', 'dead', 'unknown']; // filtrelemede bulunan  durum çeşitleri
    final possibleSpecies = ['human', 'alien', 'robot', 'humanoid', 'animal']; // filtrelemede bulunan tür çeşitleri

    for (var word in words) {
      if (possibleStatus.contains(word)) {
        _filters['status'] = word; // status filtreye eklenir
      } else if (possibleSpecies.contains(word)) {
        _filters['species'] = word; // species filtreye eklenir
      } else {
        nameParts.add(word); // kalan kelimeler name aramasına eklenir
      }
    }

    if (nameParts.isNotEmpty) {
      _filters['name'] = nameParts.join(' ');
    }
  }

  Future<void> loadInitialCharacters() async {
    isLoading = true;
    notifyListeners();

    try {
      final url = _buildUrl();
      print("İlk Yükleme URL'si: $url");
      final response = await CharacterService.fetchCharacters(url);
      characters = response.results;
      _nextPageUrl = response.nextPageUrl;
    } catch (e) {
      print("İlk yükleme hatası: $e");
      characters = [];
      _nextPageUrl = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreCharacters() async { // daha fazla karakter çekerek sayfalama
    if (isLoading || _nextPageUrl == null) return; // eğer bir sonraki sayfa boşsa çık

    isLoading = true;
    notifyListeners();

    try {
      final response = await CharacterService.fetchCharacters(_nextPageUrl!); // sayfa varsa url ile çağrılır
      characters.addAll(response.results); // yeni karakterler listeye eklenir
      _nextPageUrl = response.nextPageUrl; // sonraki sayfa url’si kopyalanır
    } catch (e) {
      print("Devam yükleme hatası: $e"); // hata varsa ekrana bas
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //  Tür (species) dağılımını hesaplar
  Map<String, int> getSpeciesDistribution() {
    final Map<String, int> distribution = {};
    for (var character in characters) {
      distribution[character.species] = (distribution[character.species] ?? 0) + 1;
    }
    return distribution;
  }

  //  Durum (status: alive/dead/unknown) dağılımını hesaplar
  Map<String, int> getStatusDistribution() {
    final Map<String, int> distribution = {};
    for (var character in characters) {
      distribution[character.status] = (distribution[character.status] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  void dispose() {
    _debounce?.cancel(); // timer’ı temizle
    super.dispose();
  }
}
