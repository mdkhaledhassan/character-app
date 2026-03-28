#  Rick and Morty Character Explorer (Flutter)

#  Clone project
```bash
git clone https://github.com/mdkhaledhassan/character-app
cd character-app
```
#  Install Dependencies
```bash
flutter pub get
```
#  Run the Application
```bash
flutter run
```

#  Requirements
- Flutter SDK (3.x recommended)
- Dart SDK
- Android Studio / VS Code
- Android Emulator / iOS Simulator / Physical Device

#  State Management Choice
GetX

This project uses GetX for:

- State Management
- Route Management
- Dependency Injection (Bindings)

#  Why GetX?
- Lightweight and high performance
- Minimal boilerplate
- Reactive state using .obs
- Built-in routing system
- Clean separation of UI and business logic
- Easy controller lifecycle management

#  Architecture Structure
- Controllers → Business logic & state handling
- Views → UI components
- Bindings → Dependency injection
- Routes → Named navigation system

This ensures the app is scalable, maintainable, and easy to extend.

#  Storage Approach Explanation
Hive (Offline-First Strategy)

The app supports both online and offline mode using Hive as local database storage.

#  Data Flow
When Online:
- Characters are fetched from the API
- Data is saved into Hive
- UI updates reactively
 
When Offline:
- Characters are loaded from Hive
- Search and filtering work locally

Editing System:
O- nly edited fields are stored in overridesBox
- Original API data remains unchanged

A merge system dynamically combines:
- Base API data
- Local overrides

Reset Feature:
- Removes override entry
- Restores original API data

This approach ensures data integrity and clean separation between API data and local modifications.

#  Known Limitations
- Offline mode works only for previously fetched data
- No background synchronization implemented
- Filtering is performed in-memory
- No authentication system
- Minimal API error handling
- No unit/widget tests included

#  YouTube Explanation Video
- [Video Link](https://youtu.be/JZBQm0aiwd4) (Youtube)
- [Video Link](https://drive.google.com/file/d/1c8GDKjvBEYPuIZ6Z7NfDgynxh__FFGMI/view?usp=sharing) (Google Drive)

#  Thank You