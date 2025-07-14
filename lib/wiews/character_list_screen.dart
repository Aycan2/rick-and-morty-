// lib/views/character_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../wiewmodels/character_wiew_model.dart';
import '../wiewmodels/favorite_view_model.dart';
import 'character_detail_screen.dart';
import 'statistics_screen.dart';
import 'dart:async';

class CharacterListScreen extends StatefulWidget {
  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late ScrollController _scrollController;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final viewModel = Provider.of<CharacterViewModel>(context, listen: false);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !viewModel.isLoading) {
        viewModel.fetchMoreCharacters();
      }
    });
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<CharacterViewModel>(context, listen: false)
          .applyFiltersAndReload(query);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CharacterViewModel>();
    final favModel = context.watch<FavoriteViewModel>();
    final loc = AppLocalizations.of(context)!;

    // FAVORI LISTESI YUKLENMEDIYSE LOADING GOSTER
    if (!favModel.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.characters)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.characters),
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
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc.searchHint,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: onSearchChanged,
            ),
          ),
        ),
      ),
      body: _buildBody(viewModel, favModel, loc),
    );
  }

  Widget _buildBody(CharacterViewModel viewModel,
      FavoriteViewModel favModel, AppLocalizations loc) {
    if (viewModel.isLoading && viewModel.characters.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (viewModel.characters.isEmpty && _searchController.text.isEmpty) {
      return Center(child: Text(loc.noCharactersLoaded));
    }

    if (viewModel.characters.isEmpty && _searchController.text.isNotEmpty) {
      return Center(child: Text(loc.noCharactersFound));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount:
      viewModel.characters.length + (viewModel.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.characters.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final character = viewModel.characters[index];
        final isFav = favModel.isFavoriteSync(character.id);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CharacterDetailScreen(character: character),
                ),
              );
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                character.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              character.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${loc.speciesLabel}: ${character.species} | ${loc.statusLabel}: ${character.status}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () {
                favModel.toggleFavorite(character);
              },
            ),
          ),
        );
      },
    );
  }
}
