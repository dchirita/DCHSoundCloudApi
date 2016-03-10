//
//  DCHSoundCloudApiProgressHandler.h
//  Pods
//
//  Created by Daniel Chirita on 3/10/16.
//
//

#import <Foundation/Foundation.h>

typedef void(^DCHSoundCloudApiProgressHandler)(NSTimeInterval duration,
                                               NSTimeInterval currentTime,
                                               NSError *error);