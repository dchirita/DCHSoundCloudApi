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
#import "CocoaLumberjack.h"

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

static DCHSoundCloudApi *sharedInstance = nil;

@interface DCHSoundCloudApi()<AVAudioPlayerDelegate>

@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) DCHSoundCloudApiProgressHandler progressHandler;
@property (nonatomic, strong) NSTimer *playbackTimer;

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

- (void)playItemAtUrl:(NSString *)url
      progressHandler:(DCHSoundCloudApiProgressHandler)progressHandler{
    
    NSAssert(0 != url.length, @"DCHSoundCloudApi can't play an empty url");
    
    self.progressHandler = progressHandler;
    
    [[DCHSoundCloudResolve startAsyncWithUrl:url
                                    clientId:self.clientID] continueWithBlock:^id(BFTask *task){
        NSURL *trackURL = [NSURL URLWithString:task.result];
        
        NSURLSessionTask *sessionTask = [[NSURLSession sharedSession]
                                         dataTaskWithURL:trackURL
                                         completionHandler:^(NSData *data,
                                                             NSURLResponse *response,
                                                             NSError *error) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^(void){
                                                 if (error){
                                                     [self updateListenerWithError:error];
                                                     return;
                                                 }
                                                 
                                                 NSError *playError = nil;
                                                 
                                                 self.audioPlayer = [[AVAudioPlayer alloc]
                                                                     initWithData:data
                                                                     error:&playError];
                                                 if (playError){
                                                     [self updateListenerWithError:playError];
                                                     return;
                                                 }
                                                 
                                                 [self.audioPlayer play];
                                                 
                                                 [self updateListener];
                                                 [self startUpdatingListener];
                                             });
                                         }];
        
        [sessionTask resume];
        
        return nil;
    }];
}

#pragma mark - Delegates
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag){
        [self updateListener];
        [self cleanUp];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self updateListenerWithError:error];
    [self cleanUp];
}

#pragma mark - Private

- (AVAudioPlayer *)player{
    
    if (!self.audioPlayer){
        self.audioPlayer = [[AVAudioPlayer alloc] init];
        self.audioPlayer.delegate = self;
    }
    
    return self.audioPlayer;
}

- (void)startUpdatingListener{
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateListener)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)updateListener{
    BLOCK_EXEC(self.progressHandler, self.audioPlayer.duration, self.audioPlayer.currentTime, nil);
}

- (void)updateListenerWithError:(NSError *)error{
    BLOCK_EXEC(self.progressHandler, 0.f, 0.f, error);
}

- (void)cleanUp{
    [self.playbackTimer invalidate];
    self.playbackTimer = nil;
    
    self.audioPlayer = nil;
}

@end
