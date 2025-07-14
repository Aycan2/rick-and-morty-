import 'character_model.dart'; // Character modelini import et

class CharacterResponse { //apiden dönen cevabı modellemek için sınıf oluşturuldu
  final List<Character> results; //apiden gelen karakter lşstesini tutar
  final String? nextPageUrl;//sonraki sayfa urlsini tutar

  CharacterResponse({required this.results, this.nextPageUrl}); //bu nesnede rsults alanı reuired zorunlu tutulurken nextpage url null olabilir

  factory CharacterResponse.fromJson(Map<String, dynamic> json) { //apiden gelen json verisinden bir characterresponse nesnesi oluştu
    return CharacterResponse(
      results: (json['results'] as List) // apiden gelen rsults alanı liste halinde tuutlur karakterler
          .map((char) => Character.fromJson(char)) // listeeki json objelerini character nesnesine dönüştürdül
          .toList(), //normal listeye föndü
      nextPageUrl: json['info']['next'],
    );
  }
}
