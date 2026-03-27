import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/character_model.dart';
import '../../../data/models/character_override_model.dart';
import '../controllers/characters_controller.dart';
import '../widgets/text_field_widget.dart';

class CharacterEditScreen extends StatefulWidget {
  final CharacterModel character;
  const CharacterEditScreen({super.key, required this.character});

  @override
  State<CharacterEditScreen> createState() => _CharacterEditScreenState();
}

class _CharacterEditScreenState extends State<CharacterEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController statusController;
  late TextEditingController speciesController;
  late TextEditingController typeController;
  late TextEditingController genderController;
  late TextEditingController originController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    nameController = TextEditingController(text: c.name);
    statusController = TextEditingController(text: c.status);
    speciesController = TextEditingController(text: c.species);
    typeController = TextEditingController(text: c.type);
    genderController = TextEditingController(text: c.gender);
    originController = TextEditingController(text: c.originName);
    locationController = TextEditingController(text: c.locationName);
  }

  @override
  void dispose() {
    nameController.dispose();
    statusController.dispose();
    speciesController.dispose();
    typeController.dispose();
    genderController.dispose();
    originController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text("Edit Character"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFieldWidget(
                label: "Name",
                controller: nameController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Enter name';
                  } else {
                    return null;
                  }
                },
              ),
              TextFieldWidget(
                label: "Status",
                controller: statusController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Enter status';
                  } else {
                    return null;
                  }
                },
              ),
              TextFieldWidget(
                label: "Species",
                controller: speciesController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Enter species';
                  } else {
                    return null;
                  }
                },
              ),
              TextFieldWidget(
                label: "Type",
                controller: typeController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Enter type';
                  } else {
                    return null;
                  }
                },
              ),
              TextFieldWidget(
                label: "Gender",
                controller: genderController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Enter gender';
                  } else {
                    return null;
                  }
                },
              ),
              TextFieldWidget(
                label: "Origin",
                controller: originController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Enter origin';
                  } else {
                    return null;
                  }
                },
              ),
              TextFieldWidget(
                label: "Location",
                controller: locationController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Enter location';
                  } else {
                    return null;
                  }
                },
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    final override = CharacterOverride(
                      id: widget.character.id,
                      name: nameController.text,
                      status: statusController.text,
                      species: speciesController.text,
                      type: typeController.text,
                      gender: genderController.text,
                      originName: originController.text,
                      locationName: locationController.text,
                    );

                    final controller = Get.find<CharactersController>();
                    controller.saveOverride(override);
                    controller.refreshMerged();
                    Get.back(result: override);
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
                        "Save Character",
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
            ],
          ),
        ),
      ),
    );
  }
}
