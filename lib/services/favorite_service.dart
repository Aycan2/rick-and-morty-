import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/character_model.dart';

class FavoriteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //KULLANICI İÇİN FAVORİLER ALT KOLEKSİYONU
  static CollectionReference<Map<String, dynamic>> _favoritesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('favorites');
  }

  // FAVORİ EKLE
  static Future<void> addFavorite(Character character) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

    final favCol = _favoritesCollection(user.uid);

    try {
      await favCol.doc(character.id.toString()).set({
        'id': character.id,
        'name': character.name,
        'status': character.status,
        'species': character.species,
        'image': character.image,
      });
      print('Firestore: ${character.name} favorilere eklendi.');
    } catch (e) {
      print('Firestore addFavorite hatası: $e');
      rethrow;
    }
  }

  // FAVORİ SİL
  static Future<void> removeFavorite(int id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

    final favCol = _favoritesCollection(user.uid);

    try {
      await favCol.doc(id.toString()).delete();
      print('Firestore: ID $id favorilerden silindi.');
    } catch (e) {
      print('Firestore removeFavorite hatası: $e');
      rethrow;
    }
  }

  // FAVORİLERİ GETİR
  static Future<List<Character>> getFavorites(String userId) async {
    final favCol = _favoritesCollection(userId);

    try {
      final snapshot = await favCol.get();
      return snapshot.docs
          .map((doc) => Character.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Firestore getFavorites hatası: $e');
      return [];
    }
  }

  //BELİRLİ KARAKTER FAVORİ Mİ?
  static Future<bool> isFavorite(int id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final favCol = _favoritesCollection(user.uid);

    try {
      final doc = await favCol.doc(id.toString()).get();
      return doc.exists;
    } catch (e) {
      print('Firestore isFavorite hatası: $e');
      return false;
    }
  }
}

