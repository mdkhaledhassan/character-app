import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/characters_controller.dart';
import 'character_details_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final characterController = Get.put(CharactersController());

  @override
  void initState() {
    characterController.page = 1;
    characterController.localPage = 1;
    characterController.searchQuery.value = '';
    characterController.selectedSpecies.value = '';
    characterController.selectedStatus.value = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text("Characters", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 6,
                        ),
                      ),
                      onChanged: (value) => characterController.setSearch(
                        value.isEmpty ? '' : value,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                Expanded(
                  flex: 1,
                  child: Obx(() {
                    return PopupMenuButton<String>(
                      tooltip: "Filter by Species",
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: characterController.setSpeciesFilter,
                      color: Colors.white,
                      itemBuilder: (context) => ["Human", "Alien", "Unknown"]
                          .map(
                            (species) => PopupMenuItem(
                              value: species,
                              child: Text(species),
                            ),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              characterController.selectedSpecies.value.isEmpty
                                  ? "Species"
                                  : characterController.selectedSpecies.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(width: 2),

                Expanded(
                  flex: 1,
                  child: Obx(() {
                    return PopupMenuButton<String>(
                      tooltip: "Filter by Status",
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: characterController.setStatusFilter,
                      color: Colors.white,
                      itemBuilder: (context) => ["Alive", "Dead", "Unknown"]
                          .map(
                            (status) => PopupMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              characterController.selectedStatus.value.isEmpty
                                  ? "Status"
                                  : characterController.selectedStatus.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = characterController.mergedCharacters;

              if (characterController.isLoading.value && list.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!characterController.isLoading.value && list.isEmpty) {
                return const Center(
                  child: Text(
                    "No characters found",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  characterController.page = 1;
                  characterController.localPage = 1;
                  characterController.onInit();
                },
                child: ListView.builder(
                  controller: characterController.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      list.length +
                      (characterController.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == list.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
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
                        child: Container(
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
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.person, size: 40),
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
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Obx(
                                () => IconButton(
                                  icon: Icon(
                                    characterController.isFavorite(char.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => characterController
                                      .toggleFavorite(char.id),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
