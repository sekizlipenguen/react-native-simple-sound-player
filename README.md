![platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-brightgreen.svg?style=flat-square&colorB=191A17)
[![npm](https://img.shields.io/npm/v/@sekizlipenguen/react-native-simple-sound-player.svg?style=flat-square)](https://www.npmjs.com/package/@sekizlipenguen/react-native-simple-sound-player)
[![npm](https://img.shields.io/npm/dm/@sekizlipenguen/react-native-simple-sound-player.svg?style=flat-square&colorB=007ec6)](https://www.npmjs.com/package/@sekizlipenguen/react-native-simple-sound-player)
[![TypeScript](https://img.shields.io/badge/TypeScript-Ready-blue.svg?style=flat-square)](https://www.typescriptlang.org/)
[![Cache](https://img.shields.io/badge/Cache-Supported-green.svg?style=flat-square)](https://github.com/sekizlipenguen/react-native-simple-sound-player)

# @sekizlipenguen/react-native-simple-sound-player

🎵 **A lightweight and simple React Native module for playing audio files with intelligent caching**

- ✅ **Local & Remote Audio**: Play both local files and HTTPS URLs
- ✅ **Smart Caching**: Automatic cache management for remote files
- ✅ **Volume Control**: Precise volume adjustment (0.0 - 1.0)
- ✅ **Loop Support**: Infinite or fixed number of loops
- ✅ **Event System**: Listen to playback completion and errors
- ✅ **Options Pattern**: Clean API with options object
- ✅ **TypeScript Ready**: Full TypeScript support included
- ✅ **Zero Dependencies**: No external libraries required
- ✅ **Auto Linking**: Works out of the box with React Native 0.60+
- ✅ **Lightweight**: Minimal bundle size, no bloat
- ✅ **Simple API**: Easy to use, no complex configuration

---

## Installation

**Super simple installation - just one command:**

```bash
npm install @sekizlipenguen/react-native-simple-sound-player
```

### iOS Setup

After installing, run:

```bash
npx pod-install
```

### Android Setup

**No additional setup required!** The module will automatically link when you build your app.

> 💡 **That's it!** No complex configuration, no manual linking, no additional dependencies. Just install and use!

---

## 🚀 Quick Start

**Get started in seconds with these simple examples:**

```javascript
import SimpleSoundPlayer from '@sekizlipenguen/react-native-simple-sound-player';

// 🎵 Basic Usage - Just one line!
SimpleSoundPlayer.playSound('notification.mp3');

// 🔊 Volume Control - Easy as pie
SimpleSoundPlayer.playSoundWithVolume('music.mp3', 0.8);

// 🌐 Remote URLs - Works instantly
SimpleSoundPlayer.playSound('https://example.com/sound.mp3');

// 💾 Smart Caching - Automatic optimization
SimpleSoundPlayer.playSoundWithVolumeAndCache('https://example.com/music.mp3', 0.5, 3600);

// 🔁 Loop Support - Infinite or fixed loops
SimpleSoundPlayer.playSoundWithVolumeAndCacheAndLoop('ambient.mp3', 0.5, 3600, -1); // -1 = infinite

// 🎯 Options Pattern - Clean and flexible API
SimpleSoundPlayer.play({
  fileName: 'notification.mp3',
  volume: 0.8,
  loopCount: 3, // Play 3 times
  onComplete: () => console.log('Done!'),
  onError: (error) => console.error('Error:', error)
});
```

> 🎯 **No complex setup, no configuration files, no learning curve!** Just import and play.

## 📱 Usage Examples

### Local Files
```javascript
// Simple notification sound
await SimpleSoundPlayer.playSound('notification.mp3');

// Background music with low volume
await SimpleSoundPlayer.playSoundWithVolume('background.mp3', 0.3);
```

### Remote URLs
```javascript
// Direct streaming (no cache)
await SimpleSoundPlayer.playSound('https://cdn.example.com/sound.mp3');

// With caching for better performance
await SimpleSoundPlayer.playSoundWithVolumeAndCache(
  'https://cdn.example.com/music.mp3', 
  0.7, 
  7200 // 2 hours cache
);
```

### Cache Duration Examples
```javascript
// 30 minutes cache
await SimpleSoundPlayer.playSoundWithVolumeAndCache(url, 0.5, 1800);

// 1 hour cache
await SimpleSoundPlayer.playSoundWithVolumeAndCache(url, 0.5, 3600);

// 1 day cache
await SimpleSoundPlayer.playSoundWithVolumeAndCache(url, 0.5, 86400);
```

### Loop Examples
```javascript
// Infinite loop (ambient background music)
await SimpleSoundPlayer.playSoundWithVolumeAndCacheAndLoop('ambient.mp3', 0.5, 3600, -1);

// Play once (default behavior)
await SimpleSoundPlayer.playSoundWithVolumeAndCacheAndLoop('notification.mp3', 0.8, 3600, 0);

// Play 3 times
await SimpleSoundPlayer.playSoundWithVolumeAndCacheAndLoop('alarm.mp3', 1.0, 3600, 3);

// Using options pattern
await SimpleSoundPlayer.play({
  fileName: 'background.mp3',
  volume: 0.3,
  loopCount: -1, // -1 = infinite, 0 = once, >0 = number of times
});
```

### Event System Examples
```javascript
// Using callbacks in options object
await SimpleSoundPlayer.play({
  fileName: 'notification.mp3',
  onComplete: (event) => {
    console.log('Sound completed:', event);
  },
  onError: (event) => {
    console.error('Error occurred:', event);
  }
});

// Using global event listeners
const subscription = SimpleSoundPlayer.addEventListener('onSoundComplete', (event) => {
  console.log('Any sound completed:', event);
});

// Remove listener when done
SimpleSoundPlayer.removeEventListener(subscription);
```

### Complete Example with Events
```javascript
import React, {useEffect} from 'react';
import {Button, View, Alert} from 'react-native';
import SimpleSoundPlayer from '@sekizlipenguen/react-native-simple-sound-player';

const App = () => {
  useEffect(() => {
    // Global event listener
    const subscription = SimpleSoundPlayer.addEventListener('onSoundComplete', (event) => {
      console.log('Sound completed:', event);
    });

    return () => {
      SimpleSoundPlayer.removeEventListener(subscription);
    };
  }, []);

  const handlePlayWithCallback = async () => {
    try {
      await SimpleSoundPlayer.play({
        fileName: 'notification.mp3',
        volume: 0.8,
        loopCount: 0, // Play once
        onComplete: () => {
          Alert.alert('Success', 'Sound played successfully!');
        },
        onError: (error) => {
          Alert.alert('Error', error.error || 'Unknown error');
        }
      });
    } catch (error) {
      Alert.alert('Error', error.message);
    }
  };

  const handlePlayAmbient = async () => {
    try {
      await SimpleSoundPlayer.play({
        fileName: 'ambient.mp3',
        volume: 0.3,
        loopCount: -1, // Infinite loop
        onError: (error) => {
          Alert.alert('Error', error.error || 'Unknown error');
        }
      });
    } catch (error) {
      Alert.alert('Error', error.message);
    }
  };

  return (
    <View style={{flex: 1, justifyContent: 'center', padding: 20}}>
      <Button title="Play Notification" onPress={handlePlayWithCallback} />
      <View style={{height: 20}} />
      <Button title="Play Ambient (Infinite)" onPress={handlePlayAmbient} />
    </View>
  );
};

export default App;
```

### Complete Example

```javascript
import React, {useState} from 'react';
import {Button, View, Alert, Text, StyleSheet} from 'react-native';
import SimpleSoundPlayer from '@sekizlipenguen/react-native-simple-sound-player';

const App = () => {
  const [isPlaying, setIsPlaying] = useState(false);

  const handlePlayLocalSound = async () => {
    try {
      setIsPlaying(true);
      const result = await SimpleSoundPlayer.playSoundWithVolume('notification.mp3', 0.8);
      console.log('Local sound played:', result);
      Alert.alert('Success', 'Local sound played successfully!');
    } catch (error) {
      Alert.alert('Error', 'Failed to play local sound: ' + error.message);
    } finally {
      setIsPlaying(false);
    }
  };

  const handlePlayRemoteSound = async () => {
    try {
      setIsPlaying(true);
      const result = await SimpleSoundPlayer.playSoundWithVolumeAndCache(
        'https://cdn.pixabay.com/download/audio/2022/03/22/audio_e350ea2393.mp3',
        0.5,
        3600 // 1 hour cache
      );
      console.log('Remote sound played:', result);
      Alert.alert('Success', 'Remote sound played successfully!');
    } catch (error) {
      Alert.alert('Error', 'Failed to play remote sound: ' + error.message);
    } finally {
      setIsPlaying(false);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>🎵 Simple Sound Player</Text>
      
      <Button 
        title={isPlaying ? "Playing..." : "Play Local Sound"} 
        onPress={handlePlayLocalSound}
        disabled={isPlaying}
      />
      
      <View style={styles.spacer} />
      
      <Button 
        title={isPlaying ? "Playing..." : "Play Remote Sound (Cached)"} 
        onPress={handlePlayRemoteSound}
        disabled={isPlaying}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 30,
  },
  spacer: {
    height: 20,
  },
});

export default App;
```

---

## 💾 Cache System

The module includes an intelligent caching system for remote audio files:

### How It Works
- **First Play**: Downloads and caches the file locally
- **Subsequent Plays**: Uses cached file for instant playback
- **Auto Cleanup**: Removes expired cache files automatically
- **Storage**: Uses platform-specific cache directories

### Cache Locations
- **iOS**: `~/Library/Caches/SimpleSoundPlayer/`
- **Android**: `/data/data/[package]/cache/SimpleSoundPlayer/`

### Benefits
- ⚡ **Faster Playback**: No network delay on cached files
- 📱 **Offline Support**: Cached files work without internet
- 💰 **Data Savings**: Reduces bandwidth usage
- 🔄 **Auto Management**: No manual cache cleanup needed

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

## 📚 API Reference

### `playSound(fileName)`
Plays a sound file with default volume (0.5).

**Parameters:**
- `fileName` (string): Name of the sound file or URL (supports both local files and remote URLs)

**Returns:** `Promise<{success: boolean, fileName: string, volume: number}>`

**Example:**
```javascript
const result = await SimpleSoundPlayer.playSound('notification.mp3');
// {success: true, fileName: 'notification.mp3', volume: 0.5}
```

### `playSoundWithVolume(fileName, volume)`
Plays a sound file with custom volume.

**Parameters:**
- `fileName` (string): Name of the sound file or URL (supports both local files and remote URLs)
- `volume` (number): Volume level (0.0 - 1.0)

**Returns:** `Promise<{success: boolean, fileName: string, volume: number}>`

**Example:**
```javascript
const result = await SimpleSoundPlayer.playSoundWithVolume('music.mp3', 0.8);
// {success: true, fileName: 'music.mp3', volume: 0.8}
```

### `playSoundWithVolumeAndCache(fileName, volume, cacheDurationSeconds)`
Plays a remote sound file with custom volume and intelligent caching.

**Parameters:**
- `fileName` (string): URL of the remote sound file
- `volume` (number): Volume level (0.0 - 1.0)
- `cacheDurationSeconds` (number): Cache duration in seconds (e.g., 3600 for 1 hour)

**Returns:** `Promise<{success: boolean, fileName: string, volume: number}>`

**Example:**
```javascript
const result = await SimpleSoundPlayer.playSoundWithVolumeAndCache(
  'https://example.com/music.mp3', 
  0.5, 
  3600
);
// {success: true, fileName: 'https://example.com/music.mp3', volume: 0.5}
```

### `playSoundWithVolumeAndCacheAndLoop(fileName, volume, cacheDurationSeconds, loopCount)`
Plays a sound file with custom volume, caching, and loop support.

**Parameters:**
- `fileName` (string): Name of the sound file or URL
- `volume` (number): Volume level (0.0 - 1.0)
- `cacheDurationSeconds` (number): Cache duration in seconds (e.g., 3600 for 1 hour)
- `loopCount` (number):
    - `-1`: Infinite loop
    - `0`: Play once (default)
    - `>0`: Play the specified number of times (e.g., `3` plays 3 times)

**Returns:** `Promise<{success: boolean, fileName: string, volume: number}>`

**Example:**
```javascript
// Infinite loop
const result = await SimpleSoundPlayer.playSoundWithVolumeAndCacheAndLoop(
  'ambient.mp3', 
  0.5, 
  3600,
  -1
);

// Play 3 times
const result = await SimpleSoundPlayer.playSoundWithVolumeAndCacheAndLoop(
  'alarm.mp3', 
  1.0, 
  3600,
  3
);
```

### `play(options)` ⭐ Recommended
Plays a sound file using an options object. This is the recommended way to use the library as it provides a clean and flexible API.

**Parameters:**
- `options` (object):
    - `fileName` (string, required): Name of the sound file or URL
    - `volume` (number, optional): Volume level (0.0 - 1.0), default: `0.5`
    - `cacheDurationSeconds` (number, optional): Cache duration in seconds, default: `3600`
    - `loopCount` (number, optional):
        - `-1`: Infinite loop
        - `0`: Play once (default)
        - `>0`: Play the specified number of times
    - `onComplete` (function, optional): Callback when sound completes
        - Receives `event: {success: boolean}`
    - `onError` (function, optional): Callback when an error occurs
        - Receives `event: {error: string, code?: number}`

**Returns:** `Promise<{success: boolean, fileName: string, volume: number}>`

**Example:**
```javascript
// Simple usage
await SimpleSoundPlayer.play({
  fileName: 'notification.mp3'
});

// With all options
await SimpleSoundPlayer.play({
  fileName: 'ambient.mp3',
  volume: 0.3,
  cacheDurationSeconds: 7200,
  loopCount: -1, // Infinite loop
  onComplete: (event) => {
    console.log('Sound completed!', event);
  },
  onError: (event) => {
    console.error('Error:', event.error);
  }
});

// Play notification 3 times
await SimpleSoundPlayer.play({
  fileName: 'notification.mp3',
  volume: 0.8,
  loopCount: 3,
  onComplete: () => {
    Alert.alert('Done', 'Notification played 3 times');
  }
});
```

### `addEventListener(eventName, handler)`
Adds a global event listener for sound events.

**Parameters:**
- `eventName` (string): Event name (`'onSoundComplete'` or `'onSoundError'`)
- `handler` (function): Event handler function
    - For `onSoundComplete`: receives `event: {success: boolean}`
    - For `onSoundError`: receives `event: {error: string, code?: number}`

**Returns:** `{remove: () => void}` - Subscription object with `remove()` method

**Example:**
```javascript
const subscription = SimpleSoundPlayer.addEventListener('onSoundComplete', (event) => {
  console.log('Sound completed:', event);
  // {success: true}
});

// Later, remove the listener
subscription.remove();
// or
SimpleSoundPlayer.removeEventListener(subscription);
```

### `removeEventListener(subscription)`
Removes an event listener subscription.

**Parameters:**
- `subscription` (object): The subscription object returned by `addEventListener`

**Example:**
```javascript
const subscription = SimpleSoundPlayer.addEventListener('onSoundComplete', handler);
// ... later
SimpleSoundPlayer.removeEventListener(subscription);
```

### Supported Sources
- **Local files**: `notification.mp3`, `music.wav`, `sound.ogg`
- **Remote URLs**: `https://example.com/sound.mp3`, `http://example.com/music.wav`
- **Cached URLs**: Automatically cached for specified duration

### Error Handling
```javascript
// Using try-catch
try {
  const result = await SimpleSoundPlayer.playSound('nonexistent.mp3');
} catch (error) {
  console.log('Error:', error.message);
  // Possible errors:
  // - "Sound file 'nonexistent.mp3' not found"
  // - "Failed to download audio from URL: ..."
  // - "Error creating audio player: ..."
}

// Using onError callback (recommended)
await SimpleSoundPlayer.play({
  fileName: 'sound.mp3',
  onError: (event) => {
    console.error('Error:', event.error);
    console.error('Error code:', event.code);
  }
});

// Using event listener
const subscription = SimpleSoundPlayer.addEventListener('onSoundError', (event) => {
  console.error('Error occurred:', event.error);
});
```

### Loop Behavior
```javascript
// Infinite loop (-1): onComplete event is NOT fired (plays forever)
await SimpleSoundPlayer.play({
  fileName: 'ambient.mp3',
  loopCount: -1,
  onComplete: () => {
    // This will never be called for infinite loops
  }
});

// Play once (0): onComplete event fires when finished
await SimpleSoundPlayer.play({
  fileName: 'notification.mp3',
  loopCount: 0,
  onComplete: () => {
    // This will be called when sound finishes
  }
});

// Fixed loops (>0): onComplete fires after all loops complete
await SimpleSoundPlayer.play({
  fileName: 'alarm.mp3',
  loopCount: 3,
  onComplete: () => {
    // This will be called after 3 plays complete
  }
});
```

---

## 🔧 Compatibility

**Lightweight and compatible with all modern React Native projects:**

| Platform | Version | Status |
|----------|---------|--------|
| **React Native** | `>=0.60` | ✅ Fully Supported |
| **iOS** | `11.0+` | ✅ Fully Supported |
| **Android** | `API 21+` | ✅ Fully Supported |
| **TypeScript** | `3.0+` | ✅ Fully Supported |
| **JavaScript** | `ES6+` | ✅ Fully Supported |

> 📦 **Bundle Size**: ~50KB (minimal footprint)
> ⚡ **Performance**: Native implementation, no JavaScript overhead

### Features Matrix
| Feature | iOS | Android | Notes |
|---------|-----|---------|-------|
| Local Files | ✅ | ✅ | Bundle/raw resources |
| Remote URLs | ✅ | ✅ | HTTP/HTTPS support |
| Volume Control | ✅ | ✅ | 0.0 - 1.0 range |
| Caching | ✅ | ✅ | Automatic management |
| Loop Support | ✅ | ✅ | Infinite, fixed, or once |
| Event System | ✅ | ✅ | Complete and error events |
| TypeScript | ✅ | ✅ | Full type definitions |

---

## 🤝 Contribution

Contributions are welcome! Please feel free to submit a pull request or file an issue in the [GitHub repository](https://github.com/sekizlipenguen/react-native-simple-sound-player).

### Development Setup
```bash
git clone https://github.com/sekizlipenguen/react-native-simple-sound-player.git
cd react-native-simple-sound-player
npm install
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

- Built with ❤️ by [Sekizli Penguen](https://github.com/sekizlipenguen)
- Inspired by the React Native community
- Special thanks to all contributors and users
