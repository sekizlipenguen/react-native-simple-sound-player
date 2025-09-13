#import "SimpleSoundPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation SimpleSoundPlayer {
  AVAudioPlayer *_audioPlayer;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(playSound:(NSString *)soundFileName)
{
  // Ses dosyasının bundle'daki yolunu bul
  NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:nil];
  NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
  
  if (!soundFileURL) {
    NSLog(@"Ses dosyası bulunamadı: %@", soundFileName);
    return;
  }
  
  NSError *error;
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
  
  if (error) {
    NSLog(@"Ses çalma hatası: %@", error.localizedDescription);
    return;
  }
  
  [_audioPlayer setVolume:0.5]; // Orta ses seviyesi
  [_audioPlayer play];
}

RCT_EXPORT_METHOD(playSoundWithVolume:(NSString *)soundFileName volume:(float)volume)
{
  // Ses dosyasının bundle'daki yolunu bul
  NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:nil];
  NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
  
  if (!soundFileURL) {
    NSLog(@"Ses dosyası bulunamadı: %@", soundFileName);
    return;
  }
  
  NSError *error;
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
  
  if (error) {
    NSLog(@"Ses çalma hatası: %@", error.localizedDescription);
    return;
  }
  
  [_audioPlayer setVolume:volume]; // Özel ses seviyesi
  [_audioPlayer play];
}

@end
