//
//  DCHSoundCloudResolve.h
//  Pods
//
//  Created by Daniel Chirita on 3/9/16.
//
//

#import <Foundation/Foundation.h>

@class BFTask;
@interface DCHSoundCloudResolve : NSObject

+ (BFTask *)startAsyncWithUrl:(NSString *)url
                     clientId:(NSString *)clientID;
@end
