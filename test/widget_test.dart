import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staj_copy/main.dart';
import 'package:staj_copy/wiewmodels/favorite_view_model.dart';

void main() {
  testWidgets('Uygulama başlıyor ve karakter listesi ekranı yükleniyor', (WidgetTester tester) async {
    // FavoriteViewModel örneği oluştur
    final favoriteViewModel = FavoriteViewModel();

    // MyApp'i favoriteViewModel parametresi ile başlat
    await tester.pumpWidget(MyApp(favoriteViewModel: favoriteViewModel));

    // Başlık doğru mu kontrol et
    expect(find.text('Rick and Morty Karakterleri'), findsOneWidget);

    // 2 saniye beklet, ekran yenilensin
    await tester.pump(const Duration(seconds: 2));

    // ListTile widgetları görünüyor mu kontrol et
    expect(find.byType(ListTile), findsWidgets);
  });
}
