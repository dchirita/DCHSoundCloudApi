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

@end

@implementation DCHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[DCHSoundCloudApi sharedInstance] playItemAtUrl:@"https://soundcloud.com/editorsofficial/no-harm"];
}

@end
