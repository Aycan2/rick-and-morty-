import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'generated/l10n.dart'; // Lokalizasyon dosyası
import '../models/character_model.dart';
import '../wiewmodels/favorite_view_model.dart';
import '../wiews/character_detail_screen.dart';
import '../wiews/statistics_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Character> filteredFavorites = [];
  String searchText = '';

  final possibleStatus = ['alive', 'dead', 'unknown'];
  final possibleSpecies = ['human', 'alien', 'robot', 'humanoid', 'animal'];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Provider.of<FavoriteViewModel>(context, listen: false).loadFavorites();
      _applySmartFilter(searchText);
    });
  }

  void _applySmartFilter(String query) {
    final favs = Provider.of<FavoriteViewModel>(context, listen: false).favorites;
    searchText = query;

    if (query.isEmpty) {
      setState(() {
        filteredFavorites = favs;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    final words = lowerQuery.split(' ').where((s) => s.isNotEmpty).toList();

    String? filterStatus;
    String? filterSpecies;
    final nameParts = <String>[];

    for (var word in words) {
      if (possibleStatus.contains(word)) {
        filterStatus = word;
      } else if (possibleSpecies.contains(word)) {
        filterSpecies = word;
      } else {
        nameParts.add(word);
      }
    }

    final filterName = nameParts.join(' ');

    setState(() {
      filteredFavorites = favs.where((char) {
        bool matchesName = true;
        if (filterName.isNotEmpty) {
          matchesName = char.name.toLowerCase().contains(filterName);
        }

        bool matchesStatus = true;
        if (filterStatus != null) {
          matchesStatus = char.status.toLowerCase() == filterStatus;
        }

        bool matchesSpecies = true;
        if (filterSpecies != null) {
          matchesSpecies = char.species.toLowerCase() == filterSpecies;
        }

        return matchesName && matchesStatus && matchesSpecies;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StatisticsScreen()),
              );
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchHint,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _applySmartFilter,
            ),
          ),
        ),
      ),
      body: Consumer<FavoriteViewModel>(
        builder: (context, favModel, child) {
          // 🔁 Real-time güncelleme: filtreyi yeniden uygula
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _applySmartFilter(searchText);
          });

          final displayList = searchText.isEmpty
              ? favModel.favorites
              : filteredFavorites;

          if (favModel.favorites.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noFavorites));
          }

          if (displayList.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noFavoritesFound));
          }

          return ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final character = displayList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  leading: Image.network(character.image),
                  title: Text(character.name),
                  subtitle: Text('${character.species} - ${character.status}'),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      await favModel.toggleFavorite(character);
                      // Filtre anında tetikleniyor zaten
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CharacterDetailScreen(character: character),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
