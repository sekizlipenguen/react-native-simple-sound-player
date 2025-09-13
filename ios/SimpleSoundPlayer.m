#import "SimpleSoundPlayer.h"
#import <React/RCTBridge.h>

@implementation SimpleSoundPlayer

// React Native modülünün tanımlaması
RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

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
        
        audioPlayer.volume = volume;
        audioPlayer.numberOfLoops = 0;
        
        BOOL success = [audioPlayer play];
        
        if (success) {
            resolve(@{@"success": @YES, @"fileName": fileName, @"volume": @(volume)});
        } else {
            reject(@"PLAYBACK_ERROR", @"Failed to play sound", nil);
        }
    });
}

@end
