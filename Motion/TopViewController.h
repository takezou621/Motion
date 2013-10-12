//
//  TopViewController.h
//  Motion
//
//  Created by Kawai Takeshi on 2013/10/12.
//  Copyright (c) 2013年 Kawai Takeshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *confidenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
