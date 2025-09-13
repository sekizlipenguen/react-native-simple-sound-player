import {NativeModules} from 'react-native';

const {SimpleSoundPlayer} = NativeModules;

if (!SimpleSoundPlayer) {
  throw new Error(
      'SimpleSoundPlayer native module is not linked. Make sure you have properly linked the native code.',
  );
}

// Ses çalma fonksiyonunu dışa aktar
export function playSound(fileName) {
  return SimpleSoundPlayer.playSound(fileName);
}

// Volume ile ses çalma fonksiyonunu dışa aktar
export function playSoundWithVolume(fileName, volume) {
  return SimpleSoundPlayer.playSoundWithVolume(fileName, volume);
}

// Volume ve cache ile ses çalma fonksiyonunu dışa aktar
export function playSoundWithVolumeAndCache(fileName, volume, cacheDurationSeconds) {
  return SimpleSoundPlayer.playSoundWithVolumeAndCache(fileName, volume, cacheDurationSeconds);
}

export default {
  playSound,
  playSoundWithVolume,
  playSoundWithVolumeAndCache,
};
