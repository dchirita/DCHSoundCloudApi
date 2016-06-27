//
//  DCHSoundCloudApi.h
//  Pods
//
//  Created by Daniel Chirita on 3/9/16.
//
//

#import <Foundation/Foundation.h>
#import "DCHSoundCloudApiProgressHandler.h"

@interface DCHSoundCloudApi : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (instancetype)sharedInstance;

+ (void)setClientID:(NSString *)clientID;

- (void)playItemAtUrl:(NSString *)url
      progressHandler:(DCHSoundCloudApiProgressHandler)progressHandler;

- (void)stop;

@end
