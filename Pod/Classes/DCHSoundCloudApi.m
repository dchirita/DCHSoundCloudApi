//
//  DCHSoundCloudApi.m
//  Pods
//
//  Created by Daniel Chirita on 3/9/16.
//
//

#import "DCHSoundCloudApi.h"
#import "DCHSoundCloudResolve.h"
#import <AVFoundation/AVFoundation.h>

#import "Bolts.h"
#import "STKAudioPlayer.h"
#import "CocoaLumberjack.h"

static DCHSoundCloudApi *sharedInstance = nil;

@interface DCHSoundCloudApi()<STKAudioPlayerDelegate>

@property (nonatomic, copy) NSString *clientID;
@property (strong, nonatomic) STKAudioPlayer *audioPlayer;

@end

@implementation DCHSoundCloudApi

#pragma mark - Public

+ (instancetype)sharedInstance{
    NSAssert(nil != sharedInstance, @"[DCHSoundCloudApi setClientID:] has to be called before using sharedInstance");
    
    return sharedInstance;
}

+ (void)setClientID:(NSString *)clientID{
    sharedInstance = [[DCHSoundCloudApi alloc] init];
    sharedInstance.clientID = clientID;
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)playItemAtUrl:(NSString *)url{
    
    NSAssert(0 != url.length, @"DCHSoundCloudApi can't play an empty url");
    
    [[DCHSoundCloudResolve startAsyncWithUrl:url
                                    clientId:self.clientID] continueWithBlock:^id(BFTask *task){
        
        [[self player] queue:task.result];
        
        return nil;
    }];
}

#pragma mark - Delegates

/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    NSLog(@"didStartPlayingQueueItemId");
}

/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    NSLog(@"didFinishBufferingSourceWithQueueItemId");
}

/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    NSLog(@"stateChanged");
    
    if (STKAudioPlayerStatePlaying == state){
        NSLog(@"DURATION : %f| PROGRESS: %f", audioPlayer.duration, audioPlayer.progress);
    }
}

/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    NSLog(@"didFinishPlayingQueueItemId");
}

/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    NSLog(@"unexpectedError");
}

/// Optionally implemented to get logging information from the STKAudioPlayer (used internally for debugging)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer logInfo:(NSString*)line{
    NSLog(@"logInfo");
}

/// Raised when items queued items are cleared (usually because of a call to play, setDataSource or stop)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didCancelQueuedItems:(NSArray*)queuedItems{
    NSLog(@"didCancelQueuedItems");
}

#pragma mark - Private

- (STKAudioPlayer *)player{
    
    if (!self.audioPlayer){
        self.audioPlayer = [[STKAudioPlayer alloc] init];
        self.audioPlayer.delegate = self;
    }
    
    return self.audioPlayer;
}

@end
