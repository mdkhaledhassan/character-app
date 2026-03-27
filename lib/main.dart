import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/data/models/character_model.dart';
import 'app/data/models/character_override_model.dart';
import 'app/features/navbar/screens/navbar_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  await Hive.initFlutter();

  Hive.registerAdapter(CharacterModelAdapter());
  Hive.registerAdapter(CharacterOverrideAdapter());

  await Hive.openBox<CharacterModel>('characters');
  await Hive.openBox<int>('favorites');
  await Hive.openBox<CharacterOverride>('overrides');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      home: NavbarScreen(),
    );
  }
}
