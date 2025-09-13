import {playSound as jsPlaySound, playSoundWithVolume as jsPlaySoundWithVolume} from './index';

// TypeScript tip tanımlaması
export interface SimpleSoundPlayerSpec {
    playSound: (fileName: string) => Promise<{success: boolean; fileName: string; volume: number}>;
    playSoundWithVolume: (fileName: string, volume: number) => Promise<{success: boolean; fileName: string; volume: number}>;
}

// JavaScript fonksiyonlarını TypeScript'e sarıyoruz
export const playSound: SimpleSoundPlayerSpec['playSound'] = jsPlaySound;
export const playSoundWithVolume: SimpleSoundPlayerSpec['playSoundWithVolume'] = jsPlaySoundWithVolume;

export default {
    playSound,
    playSoundWithVolume,
};
