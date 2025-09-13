#import "SimpleSoundPlayer.h"

@implementation SimpleSoundPlayer

// React Native modülünün tanımlaması
RCT_EXPORT_MODULE();

// Ses çalma fonksiyonu (varsayılan volume ile)
RCT_EXPORT_METHOD(playSound:(NSString *)fileName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [self playSoundWithVolume:fileName volume:0.5 cacheDuration:3600 resolver:resolve rejecter:reject];
}

// Ses çalma fonksiyonu (volume ile)
RCT_EXPORT_METHOD(playSoundWithVolume:(NSString *)fileName
                  volume:(float)volume
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [self playSoundWithVolume:fileName volume:volume cacheDuration:3600 resolver:resolve rejecter:reject];
}

// Ses çalma fonksiyonu (volume ve cache ile)
RCT_EXPORT_METHOD(playSoundWithVolumeAndCache:(NSString *)fileName
                  volume:(float)volume
                  cacheDuration:(NSInteger)cacheDurationSeconds
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    [self playSoundWithVolume:fileName volume:volume cacheDuration:cacheDurationSeconds resolver:resolve rejecter:reject];
}

// Ana ses çalma fonksiyonu (internal)
- (void)playSoundWithVolume:(NSString *)fileName
                     volume:(float)volume
              cacheDuration:(NSInteger)cacheDurationSeconds
                   resolver:(RCTPromiseResolveBlock)resolve
                   rejecter:(RCTPromiseRejectBlock)reject
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *soundURL;
        
        // Check if fileName is a URL (starts with http:// or https://)
        if ([fileName hasPrefix:@"http://"] || [fileName hasPrefix:@"https://"]) {
            soundURL = [NSURL URLWithString:fileName];
            NSLog(@"Playing remote audio from URL: %@", fileName);
        } else {
            // Local file from bundle
            soundURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
            NSLog(@"Playing local audio file: %@", fileName);
        }
        
        if (!soundURL) {
            reject(@"FILE_NOT_FOUND", [NSString stringWithFormat:@"Sound file '%@' not found", fileName], nil);
            return;
        }
        
        NSError *error;
        AVAudioPlayer *audioPlayer;
        
        // Check if it's a remote URL
        if ([fileName hasPrefix:@"http://"] || [fileName hasPrefix:@"https://"]) {
            // For remote URLs, check cache first
            NSData *audioData = [self getCachedAudioData:fileName cacheDuration:cacheDurationSeconds];
            
            if (!audioData) {
                // Download and cache the file
                NSLog(@"Downloading audio from URL: %@", fileName);
                audioData = [NSData dataWithContentsOfURL:soundURL];
                if (!audioData) {
                    reject(@"DOWNLOAD_ERROR", [NSString stringWithFormat:@"Failed to download audio from URL: %@", fileName], nil);
                    return;
                }
                // Cache the downloaded data
                [self cacheAudioData:audioData forURL:fileName];
                NSLog(@"Audio cached for URL: %@", fileName);
            } else {
                NSLog(@"Using cached audio for URL: %@", fileName);
            }
            
            audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        } else {
            // For local files
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
        }
        
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
        NSString *sourceType = ([fileName hasPrefix:@"http://"] || [fileName hasPrefix:@"https://"]) ? @"Remote URL" : @"Local File";
        
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
                @"sessionError": sessionError ? sessionError.localizedDescription : @"None",
                @"sourceType": sourceType
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

// Cache fonksiyonları
- (NSData *)getCachedAudioData:(NSString *)url cacheDuration:(NSInteger)cacheDurationSeconds {
    NSString *cacheKey = [self getCacheKeyForURL:url];
    NSString *cachePath = [self getCachePathForKey:cacheKey];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:cachePath error:nil];
        NSDate *fileDate = [attributes objectForKey:NSFileModificationDate];
        NSTimeInterval timeSinceModified = [[NSDate date] timeIntervalSinceDate:fileDate];
        
        if (timeSinceModified < cacheDurationSeconds) {
            // Cache is still valid
            return [NSData dataWithContentsOfFile:cachePath];
        } else {
            // Cache expired, remove it
            [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
            NSLog(@"Cache expired for URL: %@", url);
        }
    }
    
    return nil;
}

- (void)cacheAudioData:(NSData *)audioData forURL:(NSString *)url {
    NSString *cacheKey = [self getCacheKeyForURL:url];
    NSString *cachePath = [self getCachePathForKey:cacheKey];
    
    // Create cache directory if it doesn't exist
    NSString *cacheDir = [cachePath stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Write data to cache
    [audioData writeToFile:cachePath atomically:YES];
}

- (NSString *)getCacheKeyForURL:(NSString *)url {
    // Create a hash of the URL for the cache key
    NSUInteger hash = [url hash];
    return [NSString stringWithFormat:@"audio_%lu", (unsigned long)hash];
}

- (NSString *)getCachePathForKey:(NSString *)cacheKey {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex:0];
    return [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"SimpleSoundPlayer/%@.mp3", cacheKey]];
}

@end
