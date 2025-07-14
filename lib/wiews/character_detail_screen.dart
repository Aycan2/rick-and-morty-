import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staj_copy/generated/l10n.dart';
import '../l10n/app_localizations.dart';
import '../models/character_model.dart';
import '../wiewmodels/favorite_view_model.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          Consumer<FavoriteViewModel>(
            builder: (context, favModel, _) {
              final isFav = favModel.isFavoriteSync(character.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  favModel.toggleFavorite(character);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  character.image,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(character.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "${AppLocalizations.of(context)!.speciesLabel} ${character.species}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              "${AppLocalizations.of(context)!.statusLabel} ${character.status}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
