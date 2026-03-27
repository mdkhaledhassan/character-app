import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/local_service.dart';
import '../../../../utils/merge_character.dart';
import '../../../data/models/character_model.dart';

class FavoritesController extends GetxController {
  final localService = LocalService();

  final favorites = <CharacterModel>[].obs;
  final mergedFavorites = <CharacterModel>[].obs;
  final scrollController = ScrollController();

  int page = 1;
  final int perPage = 20;

  final hasMoreData = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getFavorites();
    scrollController.addListener(_scrollListener);
  }

  void getFavorites() {
    if (!hasMoreData.value || isLoading.value) return;

    isLoading.value = true;

    final allIds = localService.getFavoriteIds();

    final start = (page - 1) * perPage;
    final end = (start + perPage) > allIds.length
        ? allIds.length
        : (start + perPage);

    if (start >= allIds.length) {
      hasMoreData.value = false;
      isLoading.value = false;
      return;
    }

    final idsPage = allIds.sublist(start, end);

    final chars = idsPage
        .map((id) {
          final base = localService.charactersBox.get(id);
          final override = localService.getOverride(id);
          if (base != null) {
            return mergeCharacter(base, override);
          }
          return null;
        })
        .whereType<CharacterModel>()
        .toList();

    favorites.addAll(chars);
    page++;

    if (favorites.length >= allIds.length) {
      hasMoreData.value = false;
    }

    refreshMerged();

    isLoading.value = false;
  }

  void refreshFavorites() {
    page = 1;
    hasMoreData.value = true;
    favorites.clear();
    getFavorites();
  }

  void refreshMerged() {
    mergedFavorites.value = favorites
        .map((c) => mergeCharacter(c, localService.getOverride(c.id)))
        .toList();
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      getFavorites();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
