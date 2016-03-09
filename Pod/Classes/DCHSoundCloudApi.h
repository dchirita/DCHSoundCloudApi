//
//  DCHSoundCloudApi.h
//  Pods
//
//  Created by Daniel Chirita on 3/9/16.
//
//

#import <Foundation/Foundation.h>

typedef void(^DCHSoundCloudApiProgressHandler)(NSTimeInterval duration,
                                               NSTimeInterval currentTime,
                                               NSError *error);
@interface DCHSoundCloudApi : NSObject

+ (instancetype)sharedInstance;

+ (void)setClientID:(NSString *)clientID;

- (void)playItemAtUrl:(NSString *)url
      progressHandler:(DCHSoundCloudApiProgressHandler)progressHandler;

@end
