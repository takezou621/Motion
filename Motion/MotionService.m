//
//  MotionService.m
//  ibeaconlib
//
//  Created by Kawai Takeshi on 2013/10/12.
//  Copyright (c) 2013年 Takeshi Kawai. All rights reserved.
//

#import "MotionService.h"


@implementation MotionService{
    CMStepCounter *_stepCounter;
    CMMotionActivityManager *_motionManager;
}

+ (MotionService *)sharedInstance {
    static MotionService *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    LOG_METHOD;
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _motionManager = [[CMMotionActivityManager alloc] init];
    _stepCounter = [[CMStepCounter alloc] init];
    
    return self;
}

- (void)dealloc {
    LOG_METHOD;
    
}

- (void)start:(UIViewController*)vc{
    LOG_METHOD;
    
    __weak typeof (self) weakSelf = self;
    if ([CMMotionActivityManager isActivityAvailable]) {
        [_motionManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                        withHandler:^(CMMotionActivity *activity) {
                                            [weakSelf.delegate motionStatusDidChange:[weakSelf statusOfActivity:activity]];
                                            [weakSelf.delegate motionConfidenceDidChange:[weakSelf stringFromConfidence:activity.confidence]];
                                        }];
    }
    
    if ([CMStepCounter isStepCountingAvailable]) {
        [_stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                             updateOn:1
                                          withHandler:^(NSInteger numberOfSteps, NSDate *timeStamp, NSError *error){
                                              [weakSelf.delegate stepCountDidChange:[@(numberOfSteps) stringValue]];
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

- (void)stop:(UIViewController*)vc{
    LOG_METHOD;
}

#pragma mark - helper method
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
