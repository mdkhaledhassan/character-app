import '../app/data/models/character_model.dart';
import '../app/data/models/character_override_model.dart';

CharacterModel mergeCharacter(
  CharacterModel base,
  CharacterOverride? override,
) {
  if (override == null) return base;

  return CharacterModel(
    id: base.id,
    name: override.name ?? base.name,
    status: override.status ?? base.status,
    species: override.species ?? base.species,
    type: override.type ?? base.type,
    gender: override.gender ?? base.gender,
    originName: override.originName ?? base.originName,
    locationName: override.locationName ?? base.locationName,
    image: base.image,
  );
}
