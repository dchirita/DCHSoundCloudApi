//
//  DCHSoundCloudPlayer.m
//  Pods
//
//  Created by Daniel Chirita on 3/10/16.
//
//

#import "DCHSoundCloudPlayer.h"

@import AVFoundation;

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

@interface DCHSoundCloudPlayer()<AVAudioPlayerDelegate>
    @property (nonatomic, strong) NSData *data;
    @property (nonatomic, strong) AVAudioPlayer *audioPlayer;
    @property (nonatomic, copy)   DCHSoundCloudApiProgressHandler progressHandler;
    @property (nonatomic, strong) NSTimer *playbackTimer;
@end

@implementation DCHSoundCloudPlayer

#pragma mark - Public

- (instancetype)initWithData:(NSData *)data{
    
    self = [super init];
    
    if (self){
        _data = data;
    }
    
    return self;
}

- (void)playWithProgressHandler:(DCHSoundCloudApiProgressHandler)handler{
    
    self.progressHandler = handler;
    
    NSError *error;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.data
                                                 error:&error];
    self.audioPlayer.delegate = self;
    
    if (!error){
        [self.audioPlayer play];
    }else{
        [self updateListenerWithError:error];
    }
    
    [self updateListener];
    [self startUpdatingListener];
}

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
