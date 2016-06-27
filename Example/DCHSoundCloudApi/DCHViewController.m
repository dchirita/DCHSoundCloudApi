//
//  DCHViewController.m
//  DCHSoundCloudApi
//
//  Created by Daniel Chirita on 03/09/2016.
//  Copyright (c) 2016 Daniel Chirita. All rights reserved.
//

#import "DCHViewController.h"
#import "DCHSoundCloudApi.h"

@interface DCHViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UITextField *songUrlTextField;

@end

@implementation DCHViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.songUrlTextField.text = @"https://soundcloud.com/themookiequeen/siempre-me-quedara-bebe";
}

- (IBAction)playOrPauseButtonPressed:(id)sender {
    
    if (![[DCHSoundCloudApi sharedInstance] isPlaying]){
        [self play];
        [self.playOrPauseButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self stop];
        [self.playOrPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (void)play{
    
    NSString *songURL = self.songUrlTextField.text;
    
    [[DCHSoundCloudApi sharedInstance] playItemAtUrl:songURL
                                     progressHandler:^(NSTimeInterval duration,
                                                       NSTimeInterval currentTime,
                                                       NSError *error){
                                         NSLog(@"DURATION : %f| CURRENT_TIME: %f | ERROR: %@",
                                               duration, currentTime, error);
                                     }];

}

- (void)stop{
    [[DCHSoundCloudApi sharedInstance] stop];
}

@end
