//
//  ParamsViewController.h
//  MotionCube
//
//  Created by Christopher Polito on 5/22/14.
//  Copyright (c) 2014 Christopher Polito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccelParams.h"

#define kFileName @"params"

@interface ParamsViewController : UIViewController
{
    AccelParams *params;
    
    IBOutlet UISlider *factorSlider;
    IBOutlet UISlider *muSlider;
    
    IBOutlet UISwitch *frictionSwitch;
    IBOutlet UISwitch *bounceSwitch;
    
    IBOutlet UISlider *stopSlider;
    
    UIView *toolbar;
    
    IBOutlet UIScrollView *subview;
    
    IBOutlet UIScrollView *frictionView;
    
}

@property (retain, nonatomic) AccelParams *params;


-(void) retrieveAll;
-(void) saveAll;
-(void) deleteData;


-(IBAction)save:(id)sender;

@end
