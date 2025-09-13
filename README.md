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
Add your sound files to your iOS project bundle. The library will automatically find and play them.

### Android
1. Create `android/app/src/main/res/raw/` directory
2. Add your sound files to the `raw` folder

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