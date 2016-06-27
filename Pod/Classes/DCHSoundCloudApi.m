//
//  DCHSoundCloudApi.m
//  Pods
//
//  Created by Daniel Chirita on 3/9/16.
//
//

#import "DCHSoundCloudApi.h"
#import "DCHSoundCloudResolve.h"
#import "DCHSoundCloudPlayer.h"

#import "Bolts.h"
#import "CocoaLumberjack.h"

static DCHSoundCloudApi *sharedInstance = nil;

@interface DCHSoundCloudApi()
    @property (nonatomic, copy) NSString *clientID;
    @property (nonatomic, strong) DCHSoundCloudPlayer *player;
@end

@implementation DCHSoundCloudApi

#pragma mark - Public

+ (instancetype)sharedInstance{
    NSAssert(nil != sharedInstance && sharedInstance.clientID != nil, @"[DCHSoundCloudApi setClientID:] has to be called before using sharedInstance");
    
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
                                                     NSLog(@"ERROR GETTING DATA: %@", [error localizedDescription]);
                                                     return;
                                                 }
                                                 
                                                 _isPlaying = YES;
                                                 
                                                 self.player = [[DCHSoundCloudPlayer alloc] initWithData:data];
                                                 
                                                 [self.player playWithProgressHandler:progressHandler];
                                             });
                                         }];
        
        [sessionTask resume];
        
        return nil;
    }];
}

- (void)stop{
    
    _isPlaying = NO;
    
    [self.player stop];
}

@end
