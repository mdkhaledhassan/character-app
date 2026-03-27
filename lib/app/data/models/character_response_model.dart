import 'character_model.dart';

class CharacterResponse {
  final List<CharacterModel> results;
  final int totalPages;

  CharacterResponse({required this.results, required this.totalPages});

  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    return CharacterResponse(
      results: (json['results'] as List)
          .map((e) => CharacterModel.fromJson(e))
          .toList(),
      totalPages: json['info']['pages'],
    );
  }
}
