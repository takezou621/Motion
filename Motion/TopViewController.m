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
    [MotionService sharedInstance].delegate = self;
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
    /*
    if ([CMMotionActivityManager isActivityAvailable]) {
        self.activityManager = [[CMMotionActivityManager alloc] init];
        [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                              withHandler:^(CMMotionActivity *activity) {
                                                  weakSelf.statusLabel.text = [weakSelf statusOfActivity:activity];
                                                  weakSelf.confidenceLabel.text = [weakSelf stringFromConfidence:activity.confidence];
                                              }];
    }
    */
    [[MotionService sharedInstance] start:self];
    
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


@end
