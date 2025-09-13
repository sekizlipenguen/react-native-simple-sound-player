#import <React/RCTBridgeModule.h>
#import <AVFoundation/AVFoundation.h>

@interface SimpleSoundPlayer : NSObject <RCTBridgeModule>
@property (nonatomic, weak) RCTBridge *bridge;
@end
