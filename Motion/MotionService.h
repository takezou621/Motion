//
//  MotionService.h
//  ibeaconlib
//
//  Created by Kawai Takeshi on 2013/10/12.
//  Copyright (c) 2013年 Takeshi Kawai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreMotion;

@protocol MotionServiceDelegate <NSObject>
-(void)motionStatusDidChange:(NSString*)status;
-(void)motionConfidenceDidChange:(NSString*)confidence;
@end

@interface MotionService : NSObject

@property (weak,nonatomic) id<MotionServiceDelegate> delegate;

@property (nonatomic, strong) CMStepCounter *stepCounter;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *confidence;

+(MotionService *)sharedInstance;
- (void)start:(UIViewController*)vc;
- (void)stop:(UIViewController*)vc;
- (NSString *)statusOfActivity:(CMMotionActivity*)activity;
- (NSString *)stringFromConfidence:(CMMotionActivityConfidence)confidence;
@end
