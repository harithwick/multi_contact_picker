# Multi Contact Picker

[![pub](https://img.shields.io/pub/v/multi_contact_picker?label=version)](https://pub.dev/packages/multi_contact_picker)
[![pub points](https://img.shields.io/pub/points/multi_contact_picker)](https://pub.dev/packages/multi_contact_picker/score)
[![popularity](https://img.shields.io/pub/popularity/multi_contact_picker)](https://pub.dev/packages/multi_contact_picker/score)
[![likes](https://img.shields.io/pub/likes/multi_contact_picker)](https://pub.dev/packages/multi_contact_picker/score)

A highly customisable Flutter widget to read multiple contacts on Android and iOS including contact permission handling.
**Please note this package will not work on simulators**
## Get started

### Installation

iOS: Add the following key/value pair to your app's `Info.plist`
```xml
<plist version="1.0">
<dict>
    ...
    <key>NSContactsUsageDescription</key>
    <string>Reason we need access to the contact list</string>
</dict>
</plist>
```
Android: Add the following `<uses-permissions>` tags to your app's `AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" ...>
    <uses-permission android:name="android.permission.READ_CONTACTS"/>
    <uses-permission android:name="android.permission.WRITE_CONTACTS"/>
    <application ...>
    ...
```

### Usage

Multi contact can be used in two forms, as a fullscreen dialog or as a standalone screen. My personal preference is a fullscreen dialog.

#### 1. Fullscreen dialog
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (BuildContext context) {
    //Customise the MultiContactPicker to your liking
    return  MultiContactPicker();
  }).then((value) {
    if (value != null){
      debugPrint(value);
    }
  });

```

#### 2. Material Page 
```dart
Navigator.push(context,
  MaterialPageRoute(
  builder: (_) => MultiContactPicker()))
  .then((value) {
    if (value != null) {
      // List of selected contacts will be returned to you
      debugPrint(value);
    }
});

```
