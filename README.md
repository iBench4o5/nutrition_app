## Upute za instalaciju i pokretanje

### Preduvjeti
- Flutter SDK 3.x
- Android Studio / Xcode
- Firebase projekt (nutrition-app)

### Postavljanje
1. Kloniraj repozitorij:
   git clone https://github.com/[tvoj-username]/nutrition_app.git
   cd nutrition_app

2. Instaliraj dependencies:
   flutter pub get

3. Generiraj mockove za testove:
   dart run build_runner build --delete-conflicting-outputs

4. Pokreni aplikaciju:
   flutter run

5. Pokreni testove:
   flutter test

### Firebase
Aplikacija koristi Firebase Firestore. google-services.json i
GoogleService-Info.plist nisu u repozitoriju iz sigurnosnih razloga.
Za pokretanje potrebno je kreirati vlastiti Firebase projekt i
pokrenuti: flutterfire configure
