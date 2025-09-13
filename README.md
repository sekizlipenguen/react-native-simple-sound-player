![platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-brightgreen.svg?style=flat-square&colorB=191A17)
[![npm](https://img.shields.io/npm/v/@sekizlipenguen/react-native-simple-sound-player.svg?style=flat-square)](https://www.npmjs.com/package/@sekizlipenguen/react-native-simple-sound-player)
[![npm](https://img.shields.io/npm/dm/@sekizlipenguen/react-native-simple-sound-player.svg?style=flat-square&colorB=007ec6)](https://www.npmjs.com/package/@sekizlipenguen/react-native-simple-sound-player)

# @sekizlipenguen/react-native-simple-sound-player

A lightweight React Native module for playing MP3 and other audio files without external dependencies. Compatible with React Native 0.60 and above.

---

## Installation

Using npm:

```bash
npm install @sekizlipenguen/react-native-simple-sound-player
```

Using yarn:

```bash
yarn add @sekizlipenguen/react-native-simple-sound-player
```

### iOS Setup

After installing the package, make sure to run the following command to link the native iOS module:

```bash
npx pod-install
```

### Android Setup

No additional setup is required for Android. The module will automatically link when you build your app.

---

## Compatibility

- **React Native**: `>=0.60`
- **iOS**: Supported
- **Android**: Supported
- **JavaScript and TypeScript**: Fully supported

---

## Usage

### Import the Module

```javascript
import SimpleSoundPlayer from '@sekizlipenguen/react-native-simple-sound-player';
```

### Play Sound with Default Volume

Call the `playSound` method to play a sound file with default volume (0.5):

```javascript
SimpleSoundPlayer.playSound('my-sound.mp3');
```

### Play Sound with Custom Volume

Call the `playSoundWithVolume` method to play a sound file with custom volume:

```javascript
SimpleSoundPlayer.playSoundWithVolume('my-sound.mp3', 0.3);
```

#### Example:

```javascript
import React from 'react';
import {Button, View, Alert} from 'react-native';
import SimpleSoundPlayer from '@sekizlipenguen/react-native-simple-sound-player';

const App = () => {
  const handlePlaySound = async () => {
    try {
      const result = await SimpleSoundPlayer.playSound('notification.mp3');
      console.log('Sound played successfully:', result);
    } catch (error) {
      Alert.alert('Error', 'Failed to play sound: ' + error.message);
    }
  };

  const handlePlaySoundWithVolume = async () => {
    try {
      const result = await SimpleSoundPlayer.playSoundWithVolume('music.mp3', 0.7);
      console.log('Sound played with volume:', result);
    } catch (error) {
      Alert.alert('Error', 'Failed to play sound: ' + error.message);
    }
  };

  return (
      <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
        <Button title="Play Notification Sound" onPress={handlePlaySound}/>
        <Button title="Play Music with Volume" onPress={handlePlaySoundWithVolume}/>
      </View>
  );
};

export default App;
```

---

## File Locations

### iOS

#### Adding Sound Files to Xcode Project

1. **Open your iOS project in Xcode**
2. **In the Project Navigator (left sidebar), click on your project name** (the top-level folder with your project name - see image below)
3. **Right-click on your project name** and select **"Add Files to [YourProjectName]"**
4. **Navigate to your sound files** and select them
5. **In the dialog that appears:**
   - ✅ Check **"Copy items if needed"**
   - ✅ Check **"Add to target"** for your main app target
   - ✅ Select **"Create groups"** (not "Create folder references")
6. **Click "Add"**

**Important**: Always click on the **project name** (top-level folder) in the Project Navigator, not on subfolders!

**Visual Guide**: In the Project Navigator, you should see something like this:
```
📁 MyReactNativeApp              ← Click HERE (project name)
  📁 MyReactNativeApp            ← Don't click here (subfolder)
  📁 Libraries
  📁 MyReactNativeAppTests
  📁 Products
  📁 Frameworks
  📁 Pods
  📁 Resources
```

Click on the **top-level project name** (MyReactNativeApp in this example), then right-click and select "Add Files to [YourProjectName]".

#### Folder Structure Options

You can organize your sound files in any way you prefer:

```
ios/YourProjectName/
├── Sounds/                    # ✅ Custom folder (recommended)
│   ├── notifications/
│   ├── music/
│   └── effects/
├── Audio/                     # ✅ Alternative custom folder
├── Assets/Sounds/             # ✅ Nested structure
├── Resources/                 # ✅ Another option
└── sound.mp3                  # ✅ Or directly in project root
```

**Important**: The folder name doesn't matter - what matters is that files are added to the Xcode project bundle!

#### Important Notes for iOS:

- **File names**: Use simple names without spaces (e.g., `sound.mp3`, `notification.wav`)
- **Supported formats**: MP3, WAV, AAC, M4A, CAF
- **File size**: Keep files under 5MB for better performance
- **Bundle inclusion**: Files must be added to the app bundle, not just the project folder

### Android

#### Method 1: Using Android Studio (Recommended)

1. **Open your Android project in Android Studio**
2. **Navigate to `app/src/main/res/`**
3. **Right-click on `res` folder** and select "New" → "Android Resource Directory"
4. **Select "raw"** as the resource type
5. **Click "OK"** to create the `raw` folder
6. **Copy your sound files** into the `raw` folder

#### Method 2: Using File Explorer

1. **Navigate to your project folder**
2. **Go to `android/app/src/main/res/`**
3. **Create a folder named `raw`** if it doesn't exist
4. **Copy your sound files** into the `raw` folder

#### Method 3: Using Command Line

```bash
# Create raw directory if it doesn't exist
mkdir -p android/app/src/main/res/raw

# Copy your sound files
cp your-sound.mp3 android/app/src/main/res/raw/
cp notification.wav android/app/src/main/res/raw/
```

#### Important Notes for Android:

- **File names**: Use lowercase letters, numbers, and underscores only (e.g., `sound.mp3`, `notification_sound.wav`)
- **No spaces**: File names cannot contain spaces or special characters
- **Supported formats**: MP3, WAV, OGG, AAC
- **File size**: Keep files under 5MB for better performance
- **Resource naming**: Android requires specific naming conventions for resources

---

## Project Structure Example

After adding sound files, your project structure should look like this:

```
YourReactNativeProject/
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── res/
│                   └── raw/                    # Android: Fixed location
│                       ├── notification.mp3
│                       ├── button_click.wav
│                       └── background_music.ogg
├── ios/
│   └── YourProjectName/
│       ├── Sounds/                             # iOS: Custom folder (optional)
│       │   ├── notification.mp3
│       │   ├── button_click.wav
│       │   └── background_music.ogg
│       └── Audio/                              # iOS: Alternative folder
│           └── ambient_sound.mp3
└── src/
    └── components/
        └── SoundButton.js
```

**Note**: 
- **Android**: Must use `res/raw/` folder (fixed by Android system)
- **iOS**: Can use any folder structure you prefer (flexible)

---

## Supported Formats

- **MP3**: Full support
- **WAV**: Full support  
- **OGG**: Full support
- **Other formats**: Supported by native players

---

## Platform-Specific Details

### Android
- Uses `MediaPlayer` for audio playback
- Supports volume control (0.0 - 1.0)
- Automatically releases resources after playback

### iOS
- Uses `AVAudioPlayer` for audio playback
- Supports volume control (0.0 - 1.0)
- Runs on main queue for smooth performance

---

## API Reference

### `playSound(fileName)`
Plays a sound file with default volume (0.5).

**Parameters:**
- `fileName` (string): Name of the sound file

**Returns:** Promise with success status

### `playSoundWithVolume(fileName, volume)`
Plays a sound file with custom volume.

**Parameters:**
- `fileName` (string): Name of the sound file
- `volume` (number): Volume level (0.0 - 1.0)

**Returns:** Promise with success status

---

## Contribution

Contributions are welcome! Please feel free to submit a pull request or file an issue in the [GitHub repository](https://github.com/sekizlipenguen/react-native-simple-sound-player).

---

## License

This project is licensed under the [MIT License](LICENSE).