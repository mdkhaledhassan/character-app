import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/characters_controller.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/favirite_widget.dart';
import 'character_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final favoriteController = Get.put(FavoritesController());
  final characterController = Get.put(CharactersController());

  @override
  void initState() {
    favoriteController.page = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text("Favorites"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        final list = favoriteController.mergedFavorites;
        if (favoriteController.isLoading.value && list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!favoriteController.isLoading.value && list.isEmpty) {
          return const Center(
            child: Text(
              "No favorites found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          controller: favoriteController.scrollController,
          itemCount:
              list.length + (favoriteController.hasMoreData.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == list.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final char = list[index];
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => CharacterDetailsScreen(character: char),
                )?.then((_) => characterController.refreshMerged());
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FaviriteWidget(
                  char: char,
                  characterController: characterController,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
