import 'package:hive/hive.dart';

import '../app/data/models/character_model.dart';
import '../app/data/models/character_override_model.dart';

class LocalService {
  final charactersBox = Hive.box<CharacterModel>('characters');
  final favoritesBox = Hive.box<int>('favorites');
  final overridesBox = Hive.box<CharacterOverride>('overrides');

  Future<void> cacheCharacters(List<CharacterModel> list) async {
    for (var c in list) {
      charactersBox.put(c.id, c);
    }
  }

  List<CharacterModel> getAllCharacters() {
    return charactersBox.values.toList();
  }

  void toggleFavorite(int id) {
    if (favoritesBox.containsKey(id)) {
      favoritesBox.delete(id);
    } else {
      favoritesBox.put(id, id);
    }
  }

  List<int> getFavoriteIds() => favoritesBox.values.toList();

  CharacterOverride? getOverride(int id) => overridesBox.get(id);

  void saveOverride(CharacterOverride override) {
    overridesBox.put(override.id, override);
  }
}
