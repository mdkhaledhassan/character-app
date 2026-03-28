import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/character_model.dart';
import '../controllers/characters_controller.dart';

class FaviriteWidget extends StatelessWidget {
  const FaviriteWidget({
    super.key,
    required this.char,
    required this.characterController,
  });
  final CharacterModel char;
  final CharactersController characterController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: char.image,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              cacheKey: char.image,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(height: 70, width: 70, color: Colors.grey),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  char.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${char.species} - ${char.status}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          Obx(
            () => IconButton(
              icon: Icon(
                characterController.isFavorite(char.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => characterController.toggleFavorite(char.id),
            ),
          ),
        ],
      ),
    );
  }
}
