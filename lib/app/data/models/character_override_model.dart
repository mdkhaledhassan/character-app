import 'package:hive/hive.dart';
part 'character_override_model.g.dart';

@HiveType(typeId: 1)
class CharacterOverride extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? status;

  @HiveField(3)
  String? species;

  @HiveField(4)
  String? type;

  @HiveField(5)
  String? gender;

  @HiveField(6)
  String? originName;

  @HiveField(7)
  String? locationName;

  CharacterOverride({
    required this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.originName,
    this.locationName,
  });
}
