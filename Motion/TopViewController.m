//
//  TopViewController.m
//  Motion
//
//  Created by Kawai Takeshi on 2013/10/12.
//  Copyright (c) 2013年 Kawai Takeshi. All rights reserved.
//

#import "TopViewController.h"
@import CoreMotion;

@interface TopViewController ()
@property (nonatomic, strong) CMStepCounter *stepCounter;
@property (nonatomic, strong) CMMotionActivityManager *activityManager;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    LOG_METHOD;
    __weak typeof (self) weakSelf = self;
    
    // CMStepCounter
    if ([CMStepCounter isStepCountingAvailable]) {
        self.stepCounter = [[CMStepCounter alloc] init];
        [self.stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                                 updateOn:1
                                              withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error){
                                                  weakSelf.stepLabel.text = [@(numberOfSteps) stringValue];
                                              }];
    }
    // CMMotionActivityManager
    if ([CMMotionActivityManager isActivityAvailable]) {
        self.activityManager = [[CMMotionActivityManager alloc] init];
        [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                              withHandler:^(CMMotionActivity *activity) {
                                                  weakSelf.statusLabel.text = [weakSelf statusOfActivity:activity];
                                                  weakSelf.confidenceLabel.text = [weakSelf stringFromConfidence:activity.confidence];
                                              }];
    }
    
    if(![CMMotionActivityManager isActivityAvailable] || ![CMStepCounter isStepCountingAvailable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                        message:@"この端末は非対応です"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    LOG_METHOD;
    //    [self.stepCounter stopStepCountingUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MotionActivity
- (NSString *)statusOfActivity:(CMMotionActivity*)activity{
    LOG_METHOD;
    NSMutableString *status = @"".mutableCopy;
    if (activity.stationary) {
        [status appendString:@"静止"];
    }
    
    if (activity.walking) {
        if (status.length) [status appendString:@", "];
        [status appendString:@"徒歩"];
    }
    
    if (activity.running) {
        if (status.length) [status appendString:@", "];
        [status appendString:@"走る"];
    }
    
    if (activity.automotive) {
        if (status.length) [status appendString:@" ,"];
        [status appendString:@"高速移動中"];
    }
    
    if (activity.unknown || !status.length) {
        [status appendString:@"不明"];
    }
    return status;
}

- (NSString *)stringFromConfidence:(CMMotionActivityConfidence)confidence {
    LOG_METHOD;
    switch (confidence) {
        case CMMotionActivityConfidenceLow:
            return @"低";
        case CMMotionActivityConfidenceMedium:
            return @"中";
        case CMMotionActivityConfidenceHigh:
            return @"高";
        default:
            return nil;
    }
}

@end
