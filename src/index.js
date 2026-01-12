import {NativeModules, NativeEventEmitter} from 'react-native';

const {SimpleSoundPlayer} = NativeModules;

if (!SimpleSoundPlayer) {
  throw new Error(
      'SimpleSoundPlayer native module is not linked. Make sure you have properly linked the native code.',
  );
}

// Event emitter oluştur
const eventEmitter = new NativeEventEmitter(SimpleSoundPlayer);

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

// Volume, cache ve loop sayısı ile ses çalma fonksiyonunu dışa aktar
// loopCount: -1 = sonsuz loop, 0 = tek sefer, >0 = belirtilen sayıda loop
export function playSoundWithVolumeAndCacheAndLoop(fileName, volume, cacheDurationSeconds, loopCount) {
  return SimpleSoundPlayer.playSoundWithVolumeAndCacheAndLoop(fileName, volume, cacheDurationSeconds, loopCount);
}

// Options object ile ses çalma (dağıtıcı fonksiyon)
// options: { fileName, volume?, cacheDurationSeconds?, loopCount?, onComplete?, onError? }
export function play(options) {
  if (!options || !options.fileName) {
    return Promise.reject(new Error('fileName is required in options'));
  }

  const {
    fileName,
    volume = 0.5,
    cacheDurationSeconds = 3600,
    loopCount = 0,
    onComplete,
    onError,
  } = options;

  // Event listener'ları ekle
  let completeSubscription = null;
  let errorSubscription = null;

  if (onComplete) {
    completeSubscription = eventEmitter.addListener('onSoundComplete', (event) => {
      onComplete(event);
      // Tek seferlik listener ise kaldır (sonsuz loop'ta kaldırma)
      if (loopCount !== -1) {
        if (completeSubscription) completeSubscription.remove();
        if (errorSubscription) errorSubscription.remove();
      }
    });
  }

  if (onError) {
    errorSubscription = eventEmitter.addListener('onSoundError', (event) => {
      onError(event);
      // Hata durumunda her zaman listener'ları temizle
      if (completeSubscription) completeSubscription.remove();
      if (errorSubscription) errorSubscription.remove();
    });
  }

  // Ses çal
  return playSoundWithVolumeAndCacheAndLoop(fileName, volume, cacheDurationSeconds, loopCount)
  .then((result) => {
    return result;
  })
  .catch((error) => {
    // Hata durumunda listener'ları temizle
    if (completeSubscription) completeSubscription.remove();
    if (errorSubscription) errorSubscription.remove();
    throw error;
  });
}

// Event listener ekleme/kaldırma fonksiyonları
export function addEventListener(eventName, handler) {
  return eventEmitter.addListener(eventName, handler);
}

export function removeEventListener(subscription) {
  subscription.remove();
}

// Ses durdurma fonksiyonu
export function stop() {
  return SimpleSoundPlayer.stop ? SimpleSoundPlayer.stop() : Promise.resolve({success: false});
}

export default {
  playSound,
  playSoundWithVolume,
  playSoundWithVolumeAndCache,
  playSoundWithVolumeAndCacheAndLoop,
  play, // Options object ile kullanım
  addEventListener,
  removeEventListener,
  stop,
};
