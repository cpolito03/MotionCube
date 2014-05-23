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
#import "AccelParams.h"

@class Axes;

@interface Accelerometer : NSObject
{
    
    CMMotionManager *manager;
    
    GLKMatrix4 rotation;
    
    NSMutableArray *aAvg;
    
    BOOL updatePosition;
    
    double interval;
    
    AccelParams *params;
    
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
    
    int avgCount;
    double lengthThresh;
    double compThresh;
    double hz;
    
    BOOL friction;
    double mu;
    int totalToStop;
    int stopCount;
    
    double factor;
    
    BOOL bounce;
    BOOL bounceY;
    BOOL bounceX;
    
    double xBoundary;
    double yBoundary;
    double xLost;
    double yLost;
    
    
    
}

@property (readonly, nonatomic) GLKMatrix4 rotation;
@property (retain, nonatomic) Axes *position;
@property (readwrite, nonatomic) BOOL updatePosition;

-(void) setParams:(AccelParams *) accelParams;
-(void) motion;
-(void) toggleUpdatePosition;
-(void) setPosition;

@end
