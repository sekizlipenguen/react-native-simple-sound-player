#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <AVFoundation/AVFoundation.h>

@interface SimpleSoundPlayer : RCTEventEmitter <RCTBridgeModule, AVAudioPlayerDelegate>
@end
