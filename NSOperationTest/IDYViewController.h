//
//  IDYViewController.h
//  NSOperationTest
//
//  Created by 手代木 伸一 on 12/02/15.
//  Copyright (c) 2012年 paraches. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDYViewController : UIViewController

@property (nonatomic, strong) IBOutlet UISwitch *opCountSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *isConcurrent;
@property (nonatomic, strong) NSArray *urlArray;

- (IBAction)startThreads:(id)sender;

@end
