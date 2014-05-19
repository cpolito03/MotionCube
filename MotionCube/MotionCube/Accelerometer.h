//
//  Accelerometer.h
//  temp3D
//
//  Created by Christopher Polito on 11/13/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Utility.h"

@class Axes;

@interface Accelerometer : NSObject
{
    
    CMMotionManager *manager;
    
    GLKMatrix4 rotation;
    
    NSMutableArray *aAvg;
    
    double interval;
    
    Axes *acc0;
    Axes *acc1;
    Axes *vel0;
    Axes *vel1;
    Axes *pos0;
    Axes *position;
    
    double a0[3];
    double a1[3];
    double v0[3];
    double v1[3];
    double p0[3];
    double p1[3];
    int count[3];
    
    BOOL axes;
    
    
    
    
    double time0;
    double time1;
    
    Axes *zeroAccel;
    
    BOOL calibrating;
    NSMutableArray *calibration;
    
    long calCount;
    int totalToStop;
    int avgCount;
    double lengthThresh;
    double compThresh;
    double hz;
    
    int stopCount;
    
    double factor;
    
    
    
}

@property (readonly, nonatomic) GLKMatrix4 rotation;
@property (retain, nonatomic) Axes *position;

-(void) motion;

@end
