# Final


Git Clone: `https://github.com/Jnpk1/school_notifier.git`


## Goal of this project

 -Add a photo gateway to post pictures of assignments and graded assignments
 
 //If the user is taken to the login screen, click on Example Teacher button to be directed to the image uploader page. 
Once the app is loaded, click on the "Teacher Page" button located at the bottom of the list and this will take the user to a calendar page, with a button located at the bottom right of the screen labeled, "Add Picture". 

## Author: 
 - James Park

## Implementation:
 - added firebase_storage: ^10.0.1 to pubspec.yaml
 - added example images to assets folder 

## How to run the App:

1. Run git clone https://github.com/nalarkin/school_notifier.git
2. copy dependencies in `pubspec.yaml` file.
3. In CLI, type`flutter pub get` to install required plugins that were listed in the new `pubspec.yaml file`
4. To run android, in CLI type `flutter run`
5. To run web version instead. In CLI type `flutter run -d chrome --web-hostname localhost --web-port 8887`

## Build ID: 

`teamjnd.school_notifier`

## Requirements:

* flutter 2.0+ is downloaded and installed
* files that were edited within `android/app/scr/main/res/  (necessary for splash screen)
* update contents in `android/app/src/AndroidManifest.xml`
* have all files in `/lib` downloaded
* Android SDK >= 21
* compatible on Android and iOS



## Troubleshooting issues

* Clone the entire repository instead of copying certain files
* try `flutter clean` then `flutter pub get`
* install the plugins by doing `flutter get <addon>`, this was how I installed my addons. So it could have changed some config code somewhere in the project that I was unaware of.


