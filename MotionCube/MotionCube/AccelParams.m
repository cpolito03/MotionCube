//
//  AccelParams.m
//  MotionCube
//
//  Created by Christopher Polito on 5/22/14.
//  Copyright (c) 2014 Christopher Polito. All rights reserved.
//

#import "AccelParams.h"

@implementation AccelParams

@synthesize friction, mu, totalToStop, factor, bounce;


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        friction = [aDecoder decodeBoolForKey:kFriction];
        mu = [aDecoder decodeDoubleForKey:kMu];
        totalToStop = [aDecoder decodeIntegerForKey:kTotalToStop];
        factor = [aDecoder decodeDoubleForKey:kFactor];
        bounce = [aDecoder decodeBoolForKey:kBounce];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeBool:friction forKey:kFriction];
    [aCoder encodeDouble:mu forKey:kMu];
    [aCoder encodeInteger:totalToStop forKey:kTotalToStop];
    [aCoder encodeDouble:factor forKey:kFactor];
    [aCoder encodeBool:bounce forKey:kBounce];
     
}

@end
