class Character { //karakter sınıfı oluşturuldu
  final int id; // tüm değişkenler final olarak tanımlandı ve sadece bir kez atanabilir
  final String name;
  final String status;
  final String species;
  final String image;

  Character({ // yapıcı metot başlatıldı
    required this.id, // nesne oluşturuldu zorunlu alan olarak belirtildi
    required this.name,
    required this.status,
    required this.species,
    required this.image,
});
  factory Character.fromJson(Map<String,dynamic>json){
    return Character(id: json["id"], name: json["name"], status: json["status"], species: json["species"], image: json["image"]);
  }
}