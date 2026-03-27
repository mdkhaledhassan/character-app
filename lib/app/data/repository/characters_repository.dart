import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/api-list.dart';
import '../../core/server.dart';
import '../models/character_response_model.dart';

class CharactersRepo {
  static Server server = Server();

  static Future<CharacterResponse?> getCharacters(
    int page, {
    int retries = 5,
    int delay = 30,
  }) async {
    for (int i = 0; i < retries; i++) {
      try {
        final response = await server.getRequest(
          endPoint: "${APIList.baseUrl}?page=$page",
        );

        if (response.statusCode == 200) {
          return CharacterResponse.fromJson(jsonDecode(response.body));
        }

        if (response.statusCode == 429) {
          Get.snackbar(
            'Rate limited',
            "Waiting $delay seconds...",
            backgroundColor: Colors.tealAccent,
          );
          await Future.delayed(Duration(seconds: delay));
          delay *= 2;
          continue;
        }

        return null;
      } catch (e) {
        await Future.delayed(Duration(seconds: delay));
        delay *= 2;
      }
    }

    return null;
  }
}
