# app

La procédure d'installation fonctionne pour Windows / Android / vscode car je n'ai pas de mac et donc je n'ai pas pu tester dessus.

Procédure d'installation :

Installer Flutter : https://docs.flutter.dev/get-started/install

Installer Android Studio : https://developer.android.com/studio

S'assurer d'avoir github cli d'installé.

```
gh repo clone MysteryHS/Cliday-frontend-flutter
cd .\Cliday-frontend-flutter\
flutter pub get
```

Configurer un éditeur : https://docs.flutter.dev/get-started/editor

Ajouter un AVD : https://developer.android.com/studio/run/managing-avds

Selectionner l'avd créé dans vscode (en bas à droite)

https://docs.flutter.dev/get-started/test-drive?tab=vscode

Appuyer sur F5 pour lancer le debug.

Pour build l'app : ```flutter build apk --no-shrink```
