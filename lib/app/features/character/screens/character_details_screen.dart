import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/character_model.dart';
import '../../../data/models/character_override_model.dart';
import '../controllers/characters_controller.dart';
import '../widgets/info_widget.dart';
import 'character_edit_screen.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final CharacterModel character;

  CharacterDetailsScreen({super.key, required this.character});
  final controller = Get.find<CharactersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Obx(() {
          final merged = controller.getMergedCharacter(character);
          return Text(merged.name);
        }),
        actions: [
          Obx(() {
            final merged = controller.getMergedCharacter(character);
            return IconButton(
              icon: Icon(
                controller.isFavorite(merged.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => controller.toggleFavorite(merged.id),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Hero(
                tag: character.id,
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  cacheKey: character.image,
                  useOldImageOnUrlChange: true,
                  placeholder: (context, url) => Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person, size: 40),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final merged = controller.getMergedCharacter(character);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoWidget(title: "Name", value: merged.name),
                    InfoWidget(title: "Status", value: merged.status),
                    InfoWidget(title: "Species", value: merged.species),
                    InfoWidget(
                      title: "Type",
                      value: merged.type.isEmpty ? "Unknown" : merged.type,
                    ),
                    InfoWidget(title: "Gender", value: merged.gender),
                    InfoWidget(title: "Origin", value: merged.originName),
                    InfoWidget(title: "Location", value: merged.locationName),
                  ],
                );
              }),
              GestureDetector(
                onTap: () async {
                  final override = await Get.to<CharacterOverride>(
                    () => CharacterEditScreen(character: character),
                  );
                  if (override != null) {
                    controller.saveOverride(override);
                  }
                },
                child: Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: const Text(
                        "Edit Character",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
