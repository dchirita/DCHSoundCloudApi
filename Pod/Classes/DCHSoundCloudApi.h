//
//  DCHSoundCloudApi.h
//  Pods
//
//  Created by Daniel Chirita on 3/9/16.
//
//

#import <Foundation/Foundation.h>

@interface DCHSoundCloudApi : NSObject

+ (instancetype)sharedInstance;

+ (void)setClientID:(NSString *)clientID;

- (void)playItemAtUrl:(NSString *)url;

@end
