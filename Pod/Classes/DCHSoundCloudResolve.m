//
//  DCHSoundCloudResolve.m
//  Pods
//
//  Created by Daniel Chirita on 3/9/16.
//
//

#import "DCHSoundCloudResolve.h"
#import "AFHTTPSessionManager.h"
#import "Bolts.h"

@implementation DCHSoundCloudResolve

+ (BFTask *)startAsyncWithUrl:(NSString *)url
                     clientId:(NSString *)clientID{

    if ([self isUrlResolved:url]){
        return [BFTask taskWithResult:url];
    }
    
    BFTaskCompletionSource *bfTask = [BFTaskCompletionSource taskCompletionSource];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *resolveUrl = [NSString stringWithFormat:@"http://api.soundcloud.com/resolve?url=%@&client_id=%@", url, clientID];
    
    [manager GET:resolveUrl
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             [bfTask setResult:[NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@/stream?client_id=%@", responseObject[@"id"], clientID]];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [bfTask setError:error];
         }];
    
    return bfTask.task;
}

+ (BOOL)isUrlResolved:(NSString *)url{
    return  [url rangeOfString:@"https://api.soundcloud.com/tracks/"].location != NSNotFound &&
            [url rangeOfString:@"?client_id="].location != NSNotFound;
}

@end
