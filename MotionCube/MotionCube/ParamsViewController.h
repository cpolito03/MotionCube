//
//  ParamsViewController.h
//  MotionCube
//
//  Created by Christopher Polito on 5/22/14.
//  Copyright (c) 2014 Christopher Polito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccelParams.h"

@interface ParamsViewController : UIViewController
{
    AccelParams *params;
    
    IBOutlet UITextField *factorField;
    IBOutlet UITextField *muField;
    
    IBOutlet UISwitch *frictionSwitch;
    IBOutlet UISwitch *bounceSwitch;
    
    IBOutlet UISlider *stopSlider;
    
    UIView *toolbar;
    
    IBOutlet UIScrollView *subview;
    
}

@property (retain, nonatomic) AccelParams *params;

-(IBAction)save:(id)sender;

@end
