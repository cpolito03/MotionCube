//
//  AccelParams.h
//  MotionCube
//
//  Created by Christopher Polito on 5/22/14.
//  Copyright (c) 2014 Christopher Polito. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFriction @"friction"
#define kMu @"mu"
#define kTotalToStop @"kTotalToStop"
#define kFactor @"factor"
#define kBounce @"bounce"

@interface AccelParams : NSObject
{
 
    BOOL friction;
    double mu;
    int totalToStop;
    
    double factor;
    
    BOOL bounce;
    
}

@property (readwrite, nonatomic) BOOL friction;
@property (readwrite, nonatomic) double mu;
@property (readwrite, nonatomic) int totalToStop;
@property (readwrite, nonatomic) double factor;
@property (readwrite, nonatomic) BOOL bounce;

@end
