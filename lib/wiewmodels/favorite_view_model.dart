import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/character_model.dart';
import '../services/favorite_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  List<Character> favorites = [];
  bool isLoaded = false;

  StreamSubscription? _favoriteSubscription; //firestore snapshotı  dinlemek için kullanılan yöntem

  void startFavoritesListener() {   // kullanıcnın favori verisini canlı olarak dinlemeye başla

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; //kullanıcı girişi kontrolü yapılır
    if (user == null) return;

    _favoriteSubscription?.cancel(); // eski dinleyici varsa kapat

    _favoriteSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()//snapshot ile kullanıcıların favori listeleri güncel olarka alınır.
        .listen((snapshot) {
      favorites = snapshot.docs.map((doc) => Character.fromJson(doc.data())).toList();
      isLoaded = true;
      notifyListeners();
      print(" Favoriler anlık olarak güncellendi: ${favorites.length} karakter");
    });
  }

  void stopFavoritesListener() {   // Dinlemeyi durdur  kullanıcı çıkış yaptığında veya dispose sırasında

    _favoriteSubscription?.cancel();
    _favoriteSubscription = null;
  }


  Future<void> loadFavorites() async { // ilk açılışta tek seferlik statik yükleme yaplır. realtime değ,l
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Kullanıcı giriş yapmamış!');
      favorites = [];
      isLoaded = false;
      notifyListeners();
      return;
    }
    await loadFavoritesForUser(user.uid);
  }

  Future<void> loadFavoritesForUser(String userId) async {
    try {
      favorites = await FavoriteService.getFavorites(userId);// favori verileri veritabanından çekilip listeye eklenir
      isLoaded = true;
      notifyListeners();
      print('FavoriteViewModel: Favoriler yüklendi ($userId için, ${favorites.length} adet)');
    } catch (e) {
      print('FavoriteViewModel loadFavoritesForUser hatası: $e');
      favorites = [];
      isLoaded = false;
      notifyListeners();// eğer bir değişiklik varsa arayüz otomatik güncellenir .
    }
  }

  // Favori ekleme çıkarma
  Future<void> toggleFavorite(Character character) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

    try {
      final isFav = await FavoriteService.isFavorite(character.id);
      if (isFav) {
        await FavoriteService.removeFavorite(character.id);
        print('${character.name} favorilerden çıkarıldı.');
      } else {
        await FavoriteService.addFavorite(character);
        print('${character.name} favorilere eklendi.');
      }

      // Favoriler firestore üzerinden canlı güncellendiği için burada listeyi elle güncellemeye gerek yok
      // notifyListeners(); // Artık snapshot kendisi güncelliyor
    } catch (e) {
      print('FavoriteViewModel toggleFavorite hatası: $e');
    }
  }

  bool isFavoriteSync(int id) {
    return favorites.any((c) => c.id == id);
  }

  Future<bool> isFavorite(int id) async {
    try {
      return await FavoriteService.isFavorite(id);
    } catch (e) {
      print('FavoriteViewModel isFavorite hatası: $e');
      return false;
    }
  }

  int get favoriteCount => favorites.length;

  @override
  void dispose() {
    stopFavoritesListener();
    super.dispose();
  }
}
