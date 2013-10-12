//
//  TopViewController.m
//  Motion
//
//  Created by Kawai Takeshi on 2013/10/12.
//  Copyright (c) 2013年 Kawai Takeshi. All rights reserved.
//

#import "TopViewController.h"
#import "MotionService.h"
@import CoreMotion;

@interface TopViewController ()

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    LOG_METHOD;
    [super viewDidLoad];
    [MotionService sharedInstance].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    LOG_METHOD;
    [[MotionService sharedInstance] start:self];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    LOG_METHOD;
    [[MotionService sharedInstance] stop:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MotionServiceDelegate
-(void)motionStatusDidChange:(NSString *)status
{
    LOG_METHOD;
    self.statusLabel.text = status;
}

-(void)motionConfidenceDidChange:(NSString *)confidence
{
    LOG_METHOD;
    self.confidenceLabel.text = confidence;
}

-(void)stepCountDidChange:(NSString *)stepCount
{
    LOG_METHOD;
    self.stepLabel.text = stepCount;
}

@end
