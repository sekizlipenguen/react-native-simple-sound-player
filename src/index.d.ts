// Event tipleri
export interface SoundCompleteEvent {
    fileName?: string;
    success: boolean;
}

export interface SoundErrorEvent {
    error: string;
    code?: number;
}

// Options interface
export interface PlayOptions {
    fileName: string;
    volume?: number;
    cacheDurationSeconds?: number;
    loopCount?: number; // -1 = sonsuz loop, 0 = tek sefer, >0 = belirtilen sayıda loop
    onComplete?: (event: SoundCompleteEvent) => void;
    onError?: (event: SoundErrorEvent) => void;
}

// Fonksiyon imzaları
export function playSound(fileName: string): Promise<{success: boolean; fileName: string; volume: number}>;
export function playSoundWithVolume(fileName: string, volume: number): Promise<{success: boolean; fileName: string; volume: number}>;
export function playSoundWithVolumeAndCache(fileName: string, volume: number, cacheDurationSeconds: number): Promise<{success: boolean; fileName: string; volume: number}>;
export function playSoundWithVolumeAndCacheAndLoop(fileName: string, volume: number, cacheDurationSeconds: number, loopCount: number): Promise<{success: boolean; fileName: string; volume: number}>;
export function play(options: PlayOptions): Promise<{success: boolean; fileName: string; volume: number}>;
export function addEventListener(eventName: 'onSoundComplete' | 'onSoundError', handler: (event: SoundCompleteEvent | SoundErrorEvent) => void): {remove: () => void};
export function removeEventListener(subscription: {remove: () => void}): void;
