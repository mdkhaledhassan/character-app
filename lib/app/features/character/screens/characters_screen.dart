import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/characters_controller.dart';
import '../widgets/character_widget.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final characterController = Get.put(CharactersController());

  @override
  void initState() {
    characterController.searchQuery.value = '';
    characterController.selectedSpecies.value = '';
    characterController.selectedStatus.value = '';
    characterController.refreshCharacters();
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
                  characterController.refreshCharacters();
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
                        Get.toNamed(
                          Routes.details,
                          arguments: char,
                        )?.then((_) => characterController.refreshMerged());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CharacterWidget(
                          char: char,
                          characterController: characterController,
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
