//
//  DCHSoundCloudPlayer.h
//  Pods
//
//  Created by Daniel Chirita on 3/10/16.
//
//

#import <Foundation/Foundation.h>
#import "DCHSoundCloudApiProgressHandler.h"

@interface DCHSoundCloudPlayer : NSObject

- (instancetype)initWithData:(NSData *)data;

- (void)playWithProgressHandler:(DCHSoundCloudApiProgressHandler)handler;

- (void)stop;

@end
