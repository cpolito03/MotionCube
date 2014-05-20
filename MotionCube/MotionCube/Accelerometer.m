//
//  Accelerometer.m
//  temp3D
//
//  Created by Christopher Polito on 11/13/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import "Accelerometer.h"

@implementation Accelerometer

@synthesize rotation, position;

-(void) motion {
    

    calibrating = YES;
    zeroAccel = [[Axes alloc] initWithZero];
    calibration = [[NSMutableArray alloc] init];
    
    aAvg = [[NSMutableArray alloc] init];
    
    acc0 = [[Axes alloc] initWithZero];
    acc1 = [[Axes alloc] initWithZero];
    vel0 = [[Axes alloc] initWithZero];
    vel1 = [[Axes alloc] initWithZero];
    pos0 = [[Axes alloc] initWithX:0 Y:0 Z:-40];
    position = [[Axes alloc] initWithX:0 Y:0 Z:-40];
    
    for (int i = 0; i < 3; i++) {
        a0[i] = 0;
        a1[i] = 0;
        v0[i] = 0;
        v1[i] = 0;
        p0[i] = 0;
        p1[i] = 0;
        count[i] = 0;
    }
    
    p0[2] = -20;
    p1[2] = -20;
    
    axes = YES;
    calCount = 1000;
    totalToStop = 25;
    avgCount = 5;
    lengthThresh = 0.05;
    compThresh = 0.005;
    hz = 1/100;
    stopCount = 0;
    
    bounceX = YES;
    bounceY = YES;
    factor = 4;
    
    [self start];

}

-(void) start {
    
    manager = [[CMMotionManager alloc] init];
    manager.deviceMotionUpdateInterval = hz;
    
    time0 = 0;
    
    [manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
     ^(CMDeviceMotion *motion, NSError *error) {
        
        if (error == nil){
            
            [self attitudeChanged:motion];
            
            if (calibrating)
                [self calibrate:motion];
            else {
                [self findPosition:motion];
                
            }
            
        }
        
    }];
}

-(void) toggleCalibrating {
    if (calibrating) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doneCalibrating" object:nil];
        calibrating = NO;
    }
    else {
        calibrating = YES;
    }
}


- (void) attitudeChanged:(CMDeviceMotion *) motion{
    
    CMAttitude *attitude = motion.attitude;
    
    CMRotationMatrix rot = attitude.rotationMatrix;
    
    bool rotInvert;
    
    rotation = GLKMatrix4Invert(GLKMatrix4Make(rot.m11*1.0f, rot.m12*1.0f, rot.m13*1.0f, 0.0f, rot.m21*1.0f, rot.m22*1.0f, rot.m23*1.0f, 0.0f, rot.m31*1.0f, rot.m32*1.0f, rot.m33*1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f), &rotInvert);
    
    
}

-(void) calibrate:(CMDeviceMotion *) motion {
    
    CMAcceleration accel = motion.userAcceleration;
    
    Axes *calA = [[Axes alloc] initWithX:accel.x*factor Y:accel.y*factor Z:0];
    
    
    [calibration addObject:calA];
    
    
    if ([calibration count] == calCount) {
        zeroAccel = [Axes average:calibration];
        
        NSLog(@"zero accel \n %f \n %f \n %f", zeroAccel.x, zeroAccel.y, zeroAccel.z);
        
        calibration = [[NSMutableArray alloc] init];
        [self toggleCalibrating];
    }
    
}


-(void) findPosition:(CMDeviceMotion *) motion {
 
    CMAcceleration accel = motion.userAcceleration;
    
    Axes *calA = [[Axes alloc] initWithX:(accel.x*factor - zeroAccel.x) Y:(accel.y*factor - zeroAccel.y) Z:0];
    
    [aAvg addObject:calA];
    
    if ([aAvg count] == avgCount) {
        
        time1 = manager.accelerometerData.timestamp;
        
        interval = time1 - time0;
        
        if (axes) {
            [self integrateAxes];
        }
        else {
            [self integrateArray];
        }
        
        time0 = time1;
        
        aAvg = [[NSMutableArray alloc] init];
        
    }
    
}

-(void) integrateAxes {
    
    acc1 = [Axes average:aAvg];
    
    NSLog(@"current accel \n %f \n %f \n %f \n\n", acc1.x, acc1.y, acc1.z);
    
    if (acc1.length <= lengthThresh) {
        acc1 = [[Axes alloc] initWithZero];
    }
    
    if (acc1.x == 0) {
        vel0.x *= 0.9;
    }
    
    if (acc1.y == 0) {
        vel0.y *= 0.9;
    }
    
    vel1 = [[vel0 axesByAdding:acc0] axesByAdding:[[[acc1 axesBySubtracting:acc0] axesByMultiplyScalar:0.5] axesByMultiplyScalar:interval]];
    
    position = [[pos0 axesByAdding:vel0] axesByAdding:[[[vel1 axesBySubtracting:vel0] axesByMultiplyScalar:0.5] axesByMultiplyScalar:interval]];
    
//    if (fabs(position.x) < 3) {
//        bounceX = YES;
//    }
//    
//    if (fabs(position.y) < 4) {
//        bounceY = YES;
//    }
    
        if (fabs(position.x) > 6) {
            if (bounceX) {
                vel0.x = -vel1.x;
//                pos0.x = 5;
                bounceX = NO;
            }
            else {
                vel0.x = vel1.x;
            }
        }
        else {
            vel0.x = vel1.x;
            bounceX = YES;
        }
    
    
    
        if (fabs(position.y) > 15) {
            if (bounceY) {
                vel0.y = -vel1.y;
//                pos0.y = 6;
                bounceY = NO;
            }
            else {
                vel0.y = vel1.y;
            }
        }
        else {
            vel0.y = vel1.y;
            bounceY = YES;
        }
    
    acc0 = acc1;
    pos0 = position;
    
}

-(void) integrateArray {
    
    Axes *a = [Axes average:aAvg];
    
    if (fabs(a.x) <= compThresh) {
        a1[0] = 0;
    }
    else {
        a1[0] = a.x;
    }
    
    if (fabs(a.y) <= compThresh) {
        a1[1] = 0;
    }
    else {
        a1[1] = a.y;
    }
    
    if (fabs(a.z) <= compThresh) {
        a1[2] = 0;
    }
    else {
        a1[2] = a.z;
    }
    
    for (int i = 0; i < 3; i++) {
        if (a1[i] == 0) {
            count[i]++;
        }
        else {
            count[i] = 0;
        }
        
        if (count[i] == totalToStop) {
            v0[i] = 0;
            v1[i] = 0;
            count[i] = 0;
        }
        else {
            v1[i] = v0[i] + a0[i] + (a1[i] - a0[i])/2*interval;
        }
        
        p1[i] = p0[i] + v0[i] + (v1[i] - v0[i])/2*interval;
        
        p0[i] = p1[i];
        v0[i] = v1[i];
        a0[i] = a1[i];
        
    }
    
    position = [[Axes alloc] initWithX:p1[0] Y:p1[1] Z:p1[2]];
    
}


@end
