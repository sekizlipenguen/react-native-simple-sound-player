#import "SimpleSoundPlayer.h"

@implementation SimpleSoundPlayer

// React Native modülünün tanımlaması
RCT_EXPORT_MODULE();

// Ses çalma fonksiyonu (varsayılan volume ile)
RCT_EXPORT_METHOD(playSound:(NSString *)fileName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [self playSoundWithVolume:fileName volume:0.5 resolver:resolve rejecter:reject];
}

// Ses çalma fonksiyonu (özel volume ile)
RCT_EXPORT_METHOD(playSoundWithVolume:(NSString *)fileName
                  volume:(float)volume
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        if (!soundURL) {
            reject(@"FILE_NOT_FOUND", [NSString stringWithFormat:@"Sound file '%@' not found in bundle", fileName], nil);
            return;
        }
        
        NSError *error;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
        
        if (error) {
            reject(@"PLAYBACK_ERROR", [NSString stringWithFormat:@"Error creating audio player: %@", error.localizedDescription], error);
            return;
        }
        
        // Volume'u 0.0-1.0 arasında sınırla (iOS için)
        float normalizedVolume = volume;
        if (normalizedVolume > 1.0) {
            normalizedVolume = 1.0;
        } else if (normalizedVolume < 0.0) {
            normalizedVolume = 0.0;
        }
        
        audioPlayer.volume = normalizedVolume;
        audioPlayer.numberOfLoops = 0;
        audioPlayer.delegate = self; // Delegate'i ayarla
        
        // Audio session'ı aktif et
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *sessionError;
        
        // Önce session'ı deaktif et
        [audioSession setActive:NO error:&sessionError];
        
        // Kategoriyi ayarla
        [audioSession setCategory:AVAudioSessionCategoryPlayback 
                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker 
                            error:&sessionError];
        
        // Session'ı aktif et
        [audioSession setActive:YES error:&sessionError];
        
        NSLog(@"Audio session error: %@", sessionError ? sessionError.localizedDescription : @"None");
        
        // Prepare to play
        BOOL prepared = [audioPlayer prepareToPlay];
        
        // Debug bilgileri
        NSNumber *volume = @(audioPlayer.volume);
        NSNumber *duration = @(audioPlayer.duration);
        NSNumber *isPlayingBefore = @(audioPlayer.isPlaying);
        
        BOOL success = [audioPlayer play];
        NSNumber *isPlayingAfter = @(audioPlayer.isPlaying);
        
        // Kısa bir gecikme ile tekrar kontrol et
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSNumber *isPlayingDelayed = @(audioPlayer.isPlaying);
            
            // Debug bilgilerini JavaScript'e gönder
            NSDictionary *debugInfo = @{
                @"prepared": @(prepared),
                @"volume": volume,
                @"duration": duration,
                @"isPlayingBefore": isPlayingBefore,
                @"isPlayingAfter": isPlayingAfter,
                @"isPlayingDelayed": isPlayingDelayed,
                @"playResult": @(success),
                @"sessionError": sessionError ? sessionError.localizedDescription : @"None"
            };
            
            resolve(@{
                @"success": @YES, 
                @"fileName": fileName, 
                @"volume": @(normalizedVolume), 
                @"prepared": @(prepared),
                @"debug": debugInfo
            });
        });
        
        // Audio player'ı completion'da release et - ama hemen değil!
        // Ses bitene kadar bekleyelim
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((audioPlayer.duration + 1.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            audioPlayer.delegate = nil;
        });
    });
}

// AVAudioPlayerDelegate methodları
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Audio player finished playing: %@", flag ? @"Successfully" : @"With error");
    player.delegate = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Audio player decode error: %@", error.localizedDescription);
    player.delegate = nil;
}

@end
