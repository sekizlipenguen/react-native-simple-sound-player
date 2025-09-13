# React Native Simple Sound Player

A lightweight React Native library for playing sound files without external dependencies. Uses native iOS and Android audio APIs.

## Features

- ✅ No external dependencies
- ✅ Native performance
- ✅ Volume control
- ✅ iOS and Android support
- ✅ Simple API

## Installation

```bash
npm install react-native-simple-sound-player
```

## iOS Setup

1. Add your sound files to your iOS project bundle
2. The library will automatically find and play them

## Android Setup

1. Create `android/app/src/main/res/raw/` directory
2. Add your sound files to the `raw` folder
3. Add the package to your `MainApplication.java`:

```java
import com.reactnativesimplesoundplayer.SimpleSoundPlayerPackage;

// In getPackages() method:
packages.add(new SimpleSoundPlayerPackage());
```

## Usage

```javascript
import SimpleSoundPlayer from 'react-native-simple-sound-player';

// Play sound with default volume (0.5)
SimpleSoundPlayer.playSound('my-sound.mp3');

// Play sound with custom volume (0.0 - 1.0)
SimpleSoundPlayer.playSoundWithVolume('my-sound.mp3', 0.3);
```

## API

### `playSound(fileName)`
Plays a sound file with default volume (0.5).

**Parameters:**
- `fileName` (string): Name of the sound file

### `playSoundWithVolume(fileName, volume)`
Plays a sound file with custom volume.

**Parameters:**
- `fileName` (string): Name of the sound file
- `volume` (number): Volume level (0.0 - 1.0)

## File Locations

- **iOS**: Add files to your Xcode project bundle
- **Android**: Add files to `android/app/src/main/res/raw/`

## License

MIT
