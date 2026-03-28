import 'package:character_app/app/features/navbar/screens/navbar_screen.dart';
import 'package:get/get.dart';
import '../app/data/models/character_model.dart';
import '../app/features/character/bindings/characters_binding.dart';
import '../app/features/character/bindings/favorites_binding.dart';
import '../app/features/character/screens/character_details_screen.dart';
import '../app/features/character/screens/character_edit_screen.dart';
import '../app/features/character/screens/characters_screen.dart';
import '../app/features/character/screens/favorites_screen.dart';
import '../routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.initial,
      page: () => const NavbarScreen(),
      transition: Transition.fade,
      bindings: [CharactersBinding(), FavoritesBinding()],
    ),

    GetPage(
      name: Routes.home,
      page: () => const CharactersScreen(),
      transition: Transition.fade,
      binding: CharactersBinding(),
    ),

    GetPage(
      name: Routes.details,
      page: () {
        final character = Get.arguments as CharacterModel;
        return CharacterDetailsScreen(characterId: character.id);
      },
      transition: Transition.fade,
      binding: CharactersBinding(),
    ),

    GetPage(
      name: Routes.eidt,
      page: () {
        final character = Get.arguments as CharacterModel;
        return CharacterEditScreen(character: character);
      },
      transition: Transition.fade,
      binding: CharactersBinding(),
    ),

    GetPage(
      name: Routes.favorites,
      page: () => const FavoritesScreen(),
      transition: Transition.fade,
      binding: FavoritesBinding(),
    ),
  ];
}
