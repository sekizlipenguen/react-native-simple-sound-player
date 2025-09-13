import {playSound as jsPlaySound, playSoundWithVolume as jsPlaySoundWithVolume, playSoundWithVolumeAndCache as jsPlaySoundWithVolumeAndCache} from './index';

// TypeScript tip tanımlaması
export interface SimpleSoundPlayerSpec {
    playSound: (fileName: string) => Promise<{success: boolean; fileName: string; volume: number}>;
    playSoundWithVolume: (fileName: string, volume: number) => Promise<{success: boolean; fileName: string; volume: number}>;
    playSoundWithVolumeAndCache: (fileName: string, volume: number, cacheDurationSeconds: number) => Promise<{success: boolean; fileName: string; volume: number}>;
}

// JavaScript fonksiyonlarını TypeScript'e sarıyoruz
export const playSound: SimpleSoundPlayerSpec['playSound'] = jsPlaySound;
export const playSoundWithVolume: SimpleSoundPlayerSpec['playSoundWithVolume'] = jsPlaySoundWithVolume;
export const playSoundWithVolumeAndCache: SimpleSoundPlayerSpec['playSoundWithVolumeAndCache'] = jsPlaySoundWithVolumeAndCache;

export default {
    playSound,
    playSoundWithVolume,
    playSoundWithVolumeAndCache,
};
