![platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-brightgreen.svg?style=flat-square&colorB=191A17)
[![npm](https://img.shields.io/npm/v/@sekizlipenguen/react-native-simple-sound-player.svg?style=flat-square)](https://www.npmjs.com/package/@sekizlipenguen/react-native-simple-sound-player)
[![npm](https://img.shields.io/npm/dm/@sekizlipenguen/react-native-simple-sound-player.svg?style=flat-square&colorB=007ec6)](https://www.npmjs.com/package/@sekizlipenguen/react-native-simple-sound-player)

# @sekizlipenguen/react-native-simple-sound-player

A lightweight React Native module for playing MP3 and other audio files without external dependencies. Compatible with React Native 0.60 and above.

---

## Installation

```bash
npm install @sekizlipenguen/react-native-simple-sound-player
```

### iOS Setup

After installing, run:

```bash
npx pod-install
```

### Android Setup

No additional setup required. The module will automatically link when you build your app.

---

## Usage

```javascript
import SimpleSoundPlayer from '@sekizlipenguen/react-native-simple-sound-player';

// Play local sound file
SimpleSoundPlayer.playSound('notification.mp3');

// Play sound with custom volume
SimpleSoundPlayer.playSoundWithVolume('music.mp3', 0.8);

// Play remote sound from URL
SimpleSoundPlayer.playSound('https://example.com/sound.mp3');
SimpleSoundPlayer.playSoundWithVolume('https://example.com/music.mp3', 0.5);
```

### Complete Example

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

  return (
    <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
      <Button title="Play Sound" onPress={handlePlaySound}/>
    </View>
  );
};

export default App;
```

---

## Adding Sound Files

### iOS

1. **Open your iOS project in Xcode**
2. **Click on your project name** in the Project Navigator (top-level folder)
3. **Right-click** and select **"Add Files to [YourProjectName]"**
4. **Select your sound files** and click "Add"
5. **Make sure "Add to target" is checked** for your main app target

**Important**: Click on the **project name** (top-level folder), not subfolders!

### Android

1. **Navigate to** `android/app/src/main/res/`
2. **Create a folder named** `raw` if it doesn't exist
3. **Copy your sound files** into the `raw` folder

---

## File Requirements

### File Names
- **iOS**: Simple names without spaces (e.g., `sound.mp3`, `notification.wav`)
- **Android**: Lowercase letters, numbers, and underscores only (e.g., `sound.mp3`, `notification_sound.wav`)

### Supported Formats
- **MP3, WAV, OGG, AAC** - Full support
- **File size**: Keep under 5MB for better performance

---

## API Reference

### `playSound(fileName)`
Plays a sound file with default volume (0.5).

**Parameters:**
- `fileName` (string): Name of the sound file or URL (supports both local files and remote URLs)

**Returns:** Promise with success status

### `playSoundWithVolume(fileName, volume)`
Plays a sound file with custom volume.

**Parameters:**
- `fileName` (string): Name of the sound file or URL (supports both local files and remote URLs)
- `volume` (number): Volume level (0.0 - 1.0)

**Returns:** Promise with success status

### Supported Sources
- **Local files**: `notification.mp3`, `music.wav`
- **Remote URLs**: `https://example.com/sound.mp3`, `http://example.com/music.wav`

---

## Compatibility

- **React Native**: `>=0.60`
- **iOS**: Supported
- **Android**: Supported
- **JavaScript and TypeScript**: Fully supported

---

## Contribution

Contributions are welcome! Please feel free to submit a pull request or file an issue in the [GitHub repository](https://github.com/sekizlipenguen/react-native-simple-sound-player).

---

## License

This project is licensed under the [MIT License](LICENSE).