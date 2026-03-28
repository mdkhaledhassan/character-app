import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/characters_controller.dart';
import '../widgets/info_widget.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final int characterId;
  CharacterDetailsScreen({super.key, required this.characterId});

  final characterController = Get.find<CharactersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Obx(() {
          final merged = characterController.getMergedCharacterById(
            characterId,
          );
          return Text(merged.name);
        }),
        actions: [
          Obx(() {
            final merged = characterController.getMergedCharacterById(
              characterId,
            );
            return IconButton(
              icon: Icon(
                characterController.isFavorite(merged.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => characterController.toggleFavorite(merged.id),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            final merged = characterController.getMergedCharacterById(
              characterId,
            );
            return Column(
              children: [
                Hero(
                  tag: merged.id,
                  child: CachedNetworkImage(
                    imageUrl: merged.image,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheKey: merged.image,
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
                Column(
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
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final override = await Get.toNamed(
                      Routes.eidt,
                      arguments: merged,
                    );

                    if (override != null) {
                      characterController.saveOverride(override);
                    }
                  },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
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
                const SizedBox(height: 30),
              ],
            );
          }),
        ),
      ),
    );
  }
}
