import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/local_service.dart';
import '../../../../utils/merge_character.dart';
import '../../../data/models/character_model.dart';
import '../../../data/models/character_override_model.dart';
import '../../../data/repository/characters_repository.dart';
import 'favorites_controller.dart';

class CharactersController extends GetxController {
  final localService = LocalService();
  final scrollController = ScrollController();
  final characters = <CharacterModel>[].obs;
  final mergedCharacters = <CharacterModel>[].obs;
  RxMap<int, CharacterOverride> overrides = <int, CharacterOverride>{}.obs;
  final favoriteIds = <int>{}.obs;
  late Stream<List<ConnectivityResult>> _connectivityStream;

  int page = 1;
  int totalPages = 1;

  int localPage = 1;
  final int perPage = 20;

  final isLoading = false.obs;
  final hasMoreData = true.obs;
  final isOfflineMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    _initialize();

    scrollController.addListener(_scrollListener);

    _connectivityStream = Connectivity().onConnectivityChanged;

    _connectivityStream.listen((results) {
      final isConnected = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (isConnected && isOfflineMode.value) {
        isOfflineMode.value = false;
        getCharacters();
      }
    });

    favoriteIds.addAll(localService.getFavoriteIds());
  }

  Future<void> _initialize() async {
    final isConnected = await hasInternet();

    print('has internet $isConnected');

    if (isConnected) {
      isOfflineMode.value = false;
      getCharacters();
    } else {
      isOfflineMode.value = true;

      final cached = localService.getAllCharacters();

      if (cached.isNotEmpty) {
        loadLocalData();
      } else {
        hasMoreData.value = false;
      }
    }
  }

  Future<bool> hasInternet() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity()
        .checkConnectivity();

    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn) ||
        connectivityResult.contains(ConnectivityResult.bluetooth) ||
        connectivityResult.contains(ConnectivityResult.other);
  }

  void refreshMerged() {
    mergedCharacters.value = characters
        .map((c) => mergeCharacter(c, localService.getOverride(c.id)))
        .toList();
  }

  Future<void> getCharacters({bool isLoadMore = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    try {
      final response = await CharactersRepo.getCharacters(
        page,
        retries: 3,
        delay: 30,
      );

      if (response == null || response.results.isEmpty) {
        isOfflineMode.value = true;
        loadLocalData();
        return;
      }

      isOfflineMode.value = false;

      if (isLoadMore) {
        characters.addAll(response.results);
      } else {
        characters.assignAll(response.results);
        refreshMerged();
      }

      await localService.cacheCharacters(response.results);

      totalPages = response.totalPages;

      page++;
      hasMoreData.value = page <= totalPages;

      refreshMerged();

      print("API Page Loaded => ${page - 1} / $totalPages");
    } catch (e) {
      isOfflineMode.value = true;
      loadLocalData();

      refreshMerged();
    } finally {
      isLoading.value = false;
    }
  }

  void loadLocalData() {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    final all = localService.getAllCharacters();

    if (all.isEmpty) {
      hasMoreData.value = false;
      isLoading.value = false;
      return;
    }

    final start = (localPage - 1) * perPage;
    final end = start + perPage;

    if (start >= all.length) {
      hasMoreData.value = false;
      isLoading.value = false;
      return;
    }

    final newData = all.sublist(start, end > all.length ? all.length : end);

    if (localPage == 1) {
      characters.assignAll(newData);
    } else {
      characters.addAll(newData);
    }

    localPage++;
    hasMoreData.value = end < all.length;

    print("Local Page Loaded => $localPage");

    refreshMerged();
    isLoading.value = false;
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isLoading.value &&
        hasMoreData.value) {
      if (isOfflineMode.value) {
        loadLocalData();
      } else {
        getCharacters(isLoadMore: true);
      }
    }
  }

  bool isFavorite(int id) => favoriteIds.contains(id);

  void toggleFavorite(int id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    localService.toggleFavorite(id);
    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().refreshFavorites();
      Get.find<FavoritesController>().refreshMerged();
    }
  }

  CharacterModel getMergedCharacter(CharacterModel base) {
    final override = overrides[base.id];
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

  void saveOverride(CharacterOverride override) {
    localService.saveOverride(override);
    overrides[override.id] = override;
    refreshMerged();
    Get.find<FavoritesController>().refreshMerged();
  }

  void loadOverrides() {
    final all = localService.overridesBox.values.toList();
    for (var o in all) {
      overrides[o.id] = o;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
